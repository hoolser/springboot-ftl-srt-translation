# Spring Boot SRT Translation

This is a Spring Boot application that provides an API for translating SRT subtitle files from English to Greek.

## Features

-   Translate SRT files from English to Greek.
-   Support for DeepL and Azure translation services.
-   File size validation.
-   Download translated files.
-   List translated files.

## SRT Translation Batch Size Strategy

### DeepL (6 items per batch)
-   Smaller batches provide better context for gender agreement & grammar.
-   Good for quality-focused translations.
-   ~6-8 requests for 100 subtitles.

### Azure (50 items per batch)
-   LARGER batches = FEWER requests = avoid 429 rate limit errors.
-   Azure Translator supports up to 100 items per request.
-   Reduces request frequency from ~16 to 2 requests for 100 subtitles.
-   Minimizes 429 "Too Many Requests" errors.
-   Still provides reasonable translation context.
-   Azure charges per character, not per request (cost-efficient).

### Rate Limiting & Retry
-   Azure: 500ms delay between requests + exponential backoff (1s, 2s, 4s) on 429 errors.
-   Free tier: 2 requests/second.
-   Standard tier: 10 requests/second.

## Security

The `/api/srt/translation` endpoint is secured with basic authentication. You need to provide a username and password with the `ADMIN` role to access this endpoint.

The credentials can be configured in the `application.properties` file or as environment variables:

-   `app.security.username`
-   `app.security.password`

## How to Run

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/springboot-ftl-srt-translation.git
    ```
2.  **Navigate to the project directory:**
    ```bash
    cd springboot-ftl-srt-translation
    ```
3.  **Set the environment variables** for the translation provider and API keys in the `application.properties` file.
4.  **Run the application:**
    ```bash
    mvn spring-boot:run
    ```

The application will be available at `http://localhost:8080`.

## API Endpoints

-   `POST /api/srt/translation/translateEnToEl`: Translate an SRT file.
-   `GET /api/srt/translation/download?fileName={fileName}`: Download a translated file.
-   `GET /api/srt/translation/listTranslations`: List all translated files.
-   `GET /api/srt/translation/maxFileSize`: Get the maximum allowed file size.
-   `GET /api/srt/translation/provider`: Get the active translation provider.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.



## 🖥️ Running Locally

Clone the repository:

```bash
git clone https://github.com/hoolser/springboot-ftl-srt-translation.git
cd springboot-ftl-srt-translation
```

Build the project:

```bash
mvn clean package
```

Run the application:

```bash
mvn spring-boot:run
```

The app will start at: [http://localhost:8080](http://localhost:8080)

### Available Endpoints

- `/` – Home page with translation interface
- `/translate` – SRT file translation endpoint
- `/storage` – Azure Blob Storage management (if configured)
- `/api/language` – Language/locale management



### 📦 Building a JAR

Create an executable JAR:

```bash
mvn clean package
```

The JAR will be located at: `target/springboot-ftl-srt-translation-*.jar`

Run it with:

```bash
java -jar target/springboot-ftl-srt-translation-*.jar
```

## 📁 Project Structure

```
src
 └── main
      ├── java/com/tasos/demo
      │    ├── TasosApplication.java
      │    ├── config/
      │    │   ├── LocaleConfig.java
      │    │   └── StorageConstants.java
      │    ├── controller/
      │    │   ├── HomeController.java
      │    │   ├── LanguageController.java
      │    │   ├── SrtTranslationController.java
      │    │   └── StorageBlobsController.java
      │    ├── model/
      │    │   └── SrtSubtitle.java
      │    ├── service/
      │    │   ├── CourseService.java
      │    │   ├── MessageService.java
      │    │   ├── SrtTranslationService.java
      │    │   ├── StorageBlobsService.java
      │    │   └── impl/
      │    │       ├── SrtTranslationServiceImpl.java
      │    │       └── StorageBlobsServiceImpl.java
      │    └── util/
      │        └── SrtParser.java
      └── resources
           ├── templates/ [Freemarker .ftl files]
           ├── static/ [CSS, JS, images]
           ├── messages/ [i18n properties]
           └── application.properties
```

### Key Components

- **TasosApplication.java**: Spring Boot main application class
- **SrtTranslationController**: Handles SRT file upload and translation requests
- **SrtTranslationService**: Core translation logic with provider abstraction
- **SrtParser**: Parses and rebuilds SRT subtitle files
- **SrtTranslationServiceImpl**: Implements translation with batch processing
- **StorageBlobsService**: Manages file storage (locally)
- **Templates**: Freemarker templates for web UI

## 🔄 Translation Workflow

1. User uploads an SRT file via the web interface
2. Application parses the SRT file into subtitle objects
3. Subtitles are split into batches based on the configured provider
4. Each batch is sent to the translation provider (DeepL or Azure)
5. Translations are collected and reassembled into a new SRT file
6. Translated file is returned to the user for download

## 🛠️ Development

### Technologies Used

- **Java 21**
- **Spring Boot 3.x**
- **Freemarker** - Template engine
- **Azure SDK** - For Blob Storage integration
- **DeepL API** - Translation service
- **Azure Translator API** - Translation service
- **Maven** - Build tool


## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2026 Tasos Tsoukas (hoolser)

