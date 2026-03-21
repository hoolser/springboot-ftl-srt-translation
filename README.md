# 🎬 SRT Translation Application

A **Spring Boot** application for translating SRT subtitle files using either **DeepL** or **Azure Translator** APIs. This application features a user-friendly interface built with [Freemarker](https://freemarker.apache.org/) templates and supports both local file storage and Azure Blob Storage.

## 🚀 Features

- **Dual Translation Provider Support**: Choose between DeepL or Azure Translator
- **SRT File Translation**: Translate subtitle files while preserving their structure
- **Batch Processing**: Optimized batch sizes for each translation provider
- **Rate Limiting & Retry Logic**: Built-in handling for API rate limits
- **Multiple Storage Options**: Local file system or Azure Blob Storage
- **Freemarker Template Engine**: Dynamic HTML page rendering
- **Multi-language Support**: English and Greek message localization
- **Responsive Web Interface**: Modern UI for file uploads and translations



## 🏁 Getting Started

### Prerequisites

- Java 21+
- Maven 3.x
- Translation API credentials (DeepL OR Azure Translator)

### Configuration

The application uses environment variables for sensitive configuration. Configure one of the translation providers below.

#### Translation Provider Selection

Set the active translation provider in `application.properties`:

```properties
srt.translation.provider=deepl  # or 'azure'
```

#### DeepL Translation Configuration

1. **Get API Key**: Sign up at [DeepL Pro API](https://www.deepl.com/pro-api)
2. **Set Environment Variable**:
   - **Windows**: `set DEEPL_API_KEY=your_api_key_here`
   - **Linux/macOS**: `export DEEPL_API_KEY=your_api_key_here`

**DeepL Batch Size Strategy**:
- Batch size: **6 items per request**
- Smaller batches provide better context for gender agreement & grammar
- Good for quality-focused translations
- Approximately 6-8 requests for 100 subtitles

#### Azure Translator Configuration

1. **Create Azure Translator Service**: Set up in [Azure Portal](https://portal.azure.com)
2. **Set Environment Variables**:
   - **Windows**:
     ```
     set AZURE_TRANSLATOR_ENDPOINT=https://api.cognitive.microsofttranslator.com
     set AZURE_TRANSLATOR_KEY=your_api_key_here
     set AZURE_TRANSLATOR_REGION=westeurope
     ```
   - **Linux/macOS**:
     ```
     export AZURE_TRANSLATOR_ENDPOINT=https://api.cognitive.microsofttranslator.com
     export AZURE_TRANSLATOR_KEY=your_api_key_here
     export AZURE_TRANSLATOR_REGION=westeurope
     ```

**Azure Batch Size Strategy**:
- Batch size: **50 items per request**
- LARGER batches = FEWER requests = avoid 429 rate limit errors
- Azure Translator supports up to 100 items per request
- Reduces request frequency from ~16 to 2 requests for 100 subtitles
- Minimizes 429 "Too Many Requests" errors
- Still provides reasonable translation context
- Azure charges per character, not per request (cost-efficient)

**Rate Limiting & Retry**:
- 500ms delay between requests
- Exponential backoff on 429 errors: 1s, 2s, 4s
- Free tier: 2 requests/second
- Standard tier: 10 requests/second

#### Local File Storage Configuration

By default, the application stores files locally at:
```
%USERPROFILE%\tasos-storage
```

To customize, set:
```properties
local-storage-path=/your/custom/path
```

#### Azure Blob Storage Configuration (Optional)

For Azure Blob Storage integration, set the connection string:
- **Windows**: `set AZURE_STORAGE_CONNECTION_STRING=your_connection_string_here`
- **Linux/macOS**: `export AZURE_STORAGE_CONNECTION_STRING=your_connection_string_here`



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
- **StorageBlobsService**: Manages file storage (local or Azure Blob)
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

