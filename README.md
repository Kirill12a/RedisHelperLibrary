# RedisHelperLibrary

`RedisHelperLibrary` это Swift библиотека, предназначенная для упрощения работы с Redis. Библиотека предоставляет удобные методы для подключения к Redis, а также для сохранения и извлечения данных.

## Особенности
- Простое подключение к Redis.
- Удобные методы для сохранения и извлечения данных.
- Встроенная обработка ошибок.

## Предварительные требования
Перед использованием `RedisHelperLibrary`, убедитесь, что на вашем macOS установлен Redis.

### Установка Redis на macOS
Установите Redis, используя Homebrew:
```bash
brew install redis
```
Для запуска сервера Redis на локальной машине:
```bash
redis-server
```
Для отлючения сервера Redis на локальной машине:
```bash
brew services stop redis
```

## Работа на клиенте
После установки Redis на ваш компьютер выполните следующие шаги:
### Настройка Redis 
Подключение к Redis  
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        do {
            try RedisManager.shared.connect(hostname: "localhost", port: 6379)
        } catch {
            print("Failed to connect to Redis: \(error)")
        }
        return true
    }
```

Отключение от Redis
```swift
 func applicationWillTerminate(_ application: UIApplication) {
        // Отключение от Redis
        RedisManager.shared.disconnect()
        print("Disconnected from Redis")
    }
```
### Использование Redis 
В этом разделе описаны примеры использования `RedisHelperLibrary` для загрузки начальных данных и сохранения данных из текстового поля.

## Загрузка начальных данных

Метод `loadInitialData` используется для извлечения данных из Redis. Он обращается к ключу `savedString`, чтобы получить сохранённые данные и отобразить их в пользовательском интерфейсе. Если происходит ошибка, выводится сообщение об ошибке.

```swift
func loadInitialData() {
    RedisManager.shared.get(key: "savedString") { [weak self] result in
        DispatchQueue.main.async {
            switch result {
            case .success(let value):
                self?.label.text = value ?? "Введите текст"
            case .failure(let error):
                print("Failed to retrieve data: \(error)")
                self?.label.text = "Ошибка загрузки данных"
            }
        }
    }
}
```
## Сохранение текста из текстового поля

Метод `textFieldChanged` используется для сохранения текста, введённого в текстовое поле, в базу данных Redis. Это происходит при каждом изменении текста в поле. При успешном сохранении в консоль выводится сообщение о успешном сохранении данных. В случае ошибки выводится соответствующее сообщение об ошибке, что позволяет разработчикам быстро идентифицировать проблему.

Пример использования:

```swift
@objc func textFieldChanged(_ sender: UITextField) {
    guard let text = sender.text, !text.isEmpty else { return }
    RedisManager.shared.set(key: "savedString", value: text) { result in
        switch result {
        case .success():
            print("Data saved successfully")
        case .failure(let error):
            print("Failed to save data: \(error)")
        }
    }
}
```
## Вызов
```swift
 override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialData()
    }
```


