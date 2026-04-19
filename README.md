# Spring Boot SRT Translation

A user-friendly web application for translating SRT subtitle files from English to Greek using DeepL or Azure Translator services. Simply upload your SRT file, and get your translated subtitles ready to download!

## 🌐 Live Demo

You can check out the live application deployed on an Oracle Cloud VM here: 

### 🚀 [https://leaflogic.xyz/](https://leaflogic.xyz/)

## Features

-   **Easy-to-use Web Interface**: Drag-and-drop or click to upload SRT files
-   **Multiple Translation Providers**: Choose between DeepL and Azure Translator
-   **Smart Batch Processing**: Optimized batch sizes for each translation provider
-   **File Management**: Download translated files or browse your translation history
-   **Storage Management**: Manage your files through the Azure Blob Storage interface
-   **Multi-language UI**: Support for English and Greek languages
-   **Secure Access**: Admin authentication for protected features

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

## 🔐 Security

The application uses secure authentication to protect admin features. 

**For UI Access:**
- Access the application at [http://localhost:8080](http://localhost:8080) to see the home page
- When you click on the **"Go to SRT Translation"** button (or other admin features), you'll be redirected to the login page
- Enter your admin credentials (username and password)
- After successful login, you'll have access to the SRT Translation features with a **Logout** button in the top-right corner

**Credentials Configuration:**
Set these in your `application.properties` file or as environment variables:
- `app.security.username` – Admin username
- `app.security.password` – Admin password

## 🔍 OpenSearch Integration

The application features a robust OpenSearch integration hosted on a separate, dedicated Oracle Cloud VM. This remote architecture provides:
- **Live Data Searching**: Search (e.g., courses) using OpenSearch native indexing.
- **Centralized Logging**: Application and Tomcat access logs are efficiently shipped to OpenSearch in real-time via **Fluent Bit**.

## 🖥️ How to Use the Application

Once the application is running at [http://localhost:8080](http://localhost:8080), you'll see the main landing page with several options:

### 1. **SRT Translation** 
Click the **"Go to SRT Translation"** button to access the main translation interface.

**On the SRT Translation page, you can:**
- **Upload an SRT file**: Click on the upload area or drag & drop your `.srt` file
- **View file details**: See the selected file name and size
- **Clear selection**: Remove the file if needed
- **Translate**: Click the **"Translate"** button to start the translation process
- **Track progress**: Watch the real-time progress bar as your file is being translated
- **Download translated file**: Once complete, click **"Download Translated File"** to save your translated SRT
- **View translation history**: See a list of all previously translated files with download links
- **Manage provider settings**: Switch between DeepL and Azure translation services

### 2. **Storage Blob Management** 
Click the **"Go to Storage Blob Management"** button to manage files stored in Azure Blob Storage (if configured).

**Features available:**
- Upload files to cloud storage (larger file sizes available when logged in as admin)
- Browse existing files
- Download files from storage
- Delete unwanted files

### 3. **Share Blob Page** 
Click the **"Go to Share Blob Page"** button to access shared file management for collaborative workflows.

## 🚀 Getting Started

### Prerequisites
- Java 21 or later
- Maven 3.6 or later
- DeepL API key (for DeepL provider) or Azure Translator credentials (for Azure provider)

### Step 1: Obtain Translation Service Credentials

Before you can run the application, you need to set up credentials with your chosen translation provider.

#### **Option A: DeepL API**
1. Visit [DeepL API Console](https://www.deepl.com/pro/api)
2. Sign up for a free or paid account
3. Navigate to **Account Settings** → **Authentication Key**
4. Copy your API key (you'll need this later)

#### **Option B: Azure Translator**
1. Visit [Azure Portal](https://portal.azure.com/)
2. Create a new resource → Search for "Translator"
3. Create a Translator resource (Free tier available for testing)
4. Navigate to **Keys and Endpoint** section
5. Copy your **API Key** and **Endpoint URL** (you'll need these later)

### Installation & Setup

1. **Clone the repository:**
    ```bash
    git clone https://github.com/hoolser/springboot-ftl-srt-translation.git
    cd springboot-ftl-srt-translation
    ```

2. **Configure your translation provider** in `application.properties`:

**For Azure Translator:**
   ```properties
   # Choose your provider
   srt.translation.provider=azure
   
   # Add your Azure Translator credentials
   azure.translator.endpoint=https://api.cognitive.microsofttranslator.com
   azure.translator.key=YOUR_AZURE_API_KEY_HERE
   azure.translator.region=YOUR_REGION_HERE
   ```

   **For DeepL:**
   ```properties
   # Choose your provider
   srt.translation.provider=deepl
   
   # Add your DeepL API key
   deepl.api.key=YOUR_DEEPL_API_KEY_HERE
   ```


**For Your Authentication set:**
   ```properties
   # Security credentials for admin access
   app.security.username=admin
   app.security.password=your_password
   ```

   **Note:** You can also set these as environment variables:
   - `DEEPL_API_KEY` for DeepL
   - `AZURE_TRANSLATOR_ENDPOINT`, `AZURE_TRANSLATOR_KEY`, `AZURE_TRANSLATOR_REGION` for Azure
   - `APP_SECURITY_PASSWORD` for the admin password

3. **Build the project:**
    ```bash
    mvn clean package
    ```

4. **Run the application:**
    ```bash
    mvn spring-boot:run
    ```
    
    Or using the JAR file:
    ```bash
    java -jar target/springboot-ftl-srt-translation-*.jar
    ```

5. **Open in your browser:**
   Navigate to [http://localhost:8080](http://localhost:8080) and start translating!

## 📁 Project Structure

```
src
 └── main
      ├── java/com/tasos/demo
      │    ├── TasosApplication.java
      │    ├── config/
      │    │   ├── GlobalExceptionHandler.java
      │    │   ├── LocaleConfig.java
      │    │   ├── SecurityConfig.java
      │    │   └── StorageConstants.java
      │    ├── controller/
      │    │   ├── AdminBrowserController.java
      │    │   ├── HomeController.java
      │    │   ├── LoginController.java
      │    │   ├── SrtTranslationController.java
      │    │   └── StorageBlobsController.java
      │    ├── model/
      │    │   ├── FileItem.java
      │    │   └── SrtSubtitle.java
      │    ├── opensearch/
      │    │   ├── Course.java
      │    │   ├── CourseController.java
      │    │   ├── CourseService.java
      │    │   └── OpenSearchConfig.java
      │    ├── service/
      │    │   ├── AdminBrowserService.java
      │    │   ├── SrtTranslationService.java
      │    │   ├── StorageBlobsService.java
      │    │   └── impl/
      │    │       ├── AdminBrowserServiceImpl.java
      │    │       ├── SrtTranslationServiceImpl.java
      │    │       └── StorageBlobsServiceImpl.java
      │    └── util/
      │        └── SrtParser.java
      └── resources
           ├── templates/         [Freemarker .ftl files (UI, Map, Admin panels)]
           ├── static/css/        [Stylesheets (admin, dark-mode, etc.)]
           ├── static/js/         [Frontend Logic]
           ├── messages/          [i18n properties]
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
- **DeepL API** - Translation service
- **Azure Translator API** - Translation service
- **Maven** - Build tool


## 📝 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

Copyright (c) 2026 Tasos Tsoukas (hoolser)

