# Lamudi SDET Automation Exercise

This project demonstrates production-grade Web UI automation using **Robot Framework**, **SeleniumLibrary**, and a **Custom Python Library** featuring live AI/LLM evaluation.

---

## 🌟 Highlights

1. **Page Object Model (POM):** Strict separation of concerns between reusable UI keywords, locators, environment setup, and test execution files.
2. **Custom Python Library (`RealEstateHelper.py`):** Extends Robot Framework to handle regex-based currency parsing (PHP `₱`), clean raw text, and enforce strict numerical budget boundary assertions.
3. **Custom Web Component Handling:** Utilizes direct JavaScript DOM injection to bypass strict Selenium interactability blockers, allowing seamless automation of complex shadow DOM elements, custom range sliders, and dynamic UI dropdowns.
4. **Live AI Integration:** Real-time semantic analysis of unstructured property descriptions using the **OpenAI Python SDK** routed to **Groq's high-speed LLM endpoint**, replacing manual regex inspection with natural language validation.
5. **Flakiness Mitigation:** Implements adaptive retry mechanisms (`Wait Until Keyword Succeeds`), explicit waits, and JavaScript-forced clicks to handle dynamic dropdowns, DOM re-renders, and transient server errors.

---

## 🛠️ Prerequisites & Tech Stack

* **Language:** Python 3.10+
* **Framework:** Robot Framework & SeleniumLibrary
* **AI Engine:** OpenAI SDK (configured with Groq API endpoint)
* **Browser:** Google Chrome & matching ChromeDriver
* **Environment:** `python-dotenv` for credential isolation

---

## 📦 Setup Instructions

### 1. Clone the Repository
```bash
git clone <repository-url>
cd lamudi_automation
```

### 2. Set Up a Virtual Environment (Recommended)
```bash
python -m venv venv

# Windows (PowerShell)
.\venv\Scripts\Activate.ps1

# macOS/Linux
source venv/bin/activate
```

### 3. Install Dependencies
Ensure your virtual environment is activated, then install the required packages:
```bash
python -m pip install --upgrade pip
pip install -r requirements.txt
```
*(Ensure `requirements.txt` includes: `robotframework`, `robotframework-seleniumlibrary`, `openai`, and `python-dotenv`)*

### 4. 🔑 Environment Configuration (API Key)
The AI validation layer requires a Groq API key to process listing descriptions in real-time.

**How to get your free API key:**
1. Navigate to the [Groq Cloud Console API Keys page](https://console.groq.com/keys).
2. Create a free account or log in.
3. Click the **Create API Key** button and copy the generated key.

A `.env` file is included in the root directory of the project. Open it and replace the placeholder string with your actual API key:
```env
GROQ_API_KEY="gsk_your_actual_key_here"
```

---

## 🚀 Running the Tests
The test suites are categorized by complexity and functionality. Execute the following commands to run specific test groups. All outputs (logs, screenshots, and XML summaries) will be generated in the `results/` folder.

### Level 1: Simple Test Cases (Standard UI Interactions)
Validates standard web elements, search bars, and simple data comparison.
```bash
python -m robot -d results tests/search_properties.robot
```

### Level 2: Custom Test Cases (Calculators & Sliders)
Tests complex financial calculators, handling custom web components, range sliders, and dynamic inputs via JavaScript injection.
```bash
python -m robot -d results tests/loan_calculator.robot
python -m robot -d results tests/home_loans.robot
```

### Level 3: AI-Combined Test Cases (Dynamic Data Validation)
Integrates standard Selenium web scraping with real-time AI validation to determine if scraped property descriptions match a specific "vibe" or category criteria.
```bash
python -m robot -d results tests/category_buy.robot
python -m robot -d results tests/category_rent.robot
```

---

## 📊 Viewing Test Artifacts
After execution, open the generated HTML reports in any web browser to review the results and automated screenshots:
* **Detailed Execution Log:** `results/log.html`
* **High-Level Test Report:** `results/report.html`

---

## 🤖 AI Validation Architecture
* **Listing Extraction:** During UI traversal, the test scrapes unstructured property descriptions directly from the active listing card.
* **Inference Pipeline:** The text is dispatched via `RealEstateHelper.ai_validate_listing_vibe` to the Groq inference engine.
* **Strict Evaluation:** The model evaluates whether the listing satisfies the target criteria (e.g., Luxury) and returns a binary verdict (Yes/No), automatically triggering test assertions based on the response.
