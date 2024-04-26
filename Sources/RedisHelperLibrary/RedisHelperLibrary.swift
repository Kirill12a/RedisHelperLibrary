// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import RediStack
import NIO

public class RedisManager {
    public static let shared = RedisManager()
    private var connection: RedisConnection?
    private let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)

    private init() {}

    // Подключение к Redis
    public func connect(hostname: String = "localhost", port: Int = 6379) throws {
        do {
            connection = try RedisConnection.make(
                configuration: .init(hostname: hostname, port: port),
                boundEventLoop: eventLoopGroup.next()
            ).wait()
            print("Connected to Redis")
        } catch {
            print("Failed to connect to Redis: \(error)")
            throw error
        }
    }

    // Закрытие соединения
    public func disconnect() {
        do {
            try connection?.close().wait()
            try eventLoopGroup.syncShutdownGracefully()
            print("Disconnected from Redis")
        } catch {
            print("Error disconnecting from Redis: \(error)")
        }
    }

    // Сохранение строки по ключу
    public func set(key: String, value: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let connection = connection else {
            completion(.failure(RedisError.connectionError))
            return
        }
        connection.set(RedisKey(key), to: value).whenComplete { result in
            switch result {
            case .success():
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // Получение строки по ключу
    public func get(key: String, completion: @escaping (Result<String?, Error>) -> Void) {
        guard let connection = connection else {
            completion(.failure(RedisError.connectionError))
            return
        }
        connection.get(RedisKey(key), as: String.self).whenComplete { result in
            switch result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum RedisError: Error {
    case connectionError
}
