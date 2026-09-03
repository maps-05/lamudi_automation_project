*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${NAV_HOME_LOANS}          xpath=//a[@href='/home-loans' and contains(normalize-space(), 'Home loans')]

# ==========================================
# LOCATORS FOR BY TENOR
# ==========================================
${BANK_PRICE_SLIDER}       xpath=(//input[@type='range'])[1]
${BANK_DP_SLIDER}          xpath=(//input[@type='range'])[2]

${TENOR_RADIO_BTN}         xpath=//p[normalize-space()='Based on Tenor']
${TENOR_DROPDOWN_BOX}      xpath=//span[contains(@class, 'icon-ic-caret-down')]/parent::div

# ==========================================
# LOCATORS FOR BY BUDGET
# ==========================================
${BUDGET_RADIO_BTN}        xpath=//p[normalize-space()='Based on Budget']
${BUDGET_INPUT_FIELD}      xpath=//input[@placeholder='Installment Budget']

${SHOW_RESULTS_BTN}        xpath=//button[normalize-space()='Show Results']
${BANK_RESULTS_CARDS}      xpath=//h3[contains(normalize-space(), 'Our Top Bank Picks')]

*** Keywords ***
Navigate To Home Loans Page
    Wait Until Element Is Visible    ${NAV_HOME_LOANS}    timeout=10s
    Click Element                    ${NAV_HOME_LOANS}
    Sleep    2s
    Capture Page Screenshot          ${OUTPUT_DIR}/${TEST NAME}_home_loans_page_loaded.png

# ==========================================
# KEYWORDS FOR BY TENOR
# ==========================================
Calculate Top Bank Picks Based On Tenor
    [Arguments]    ${property_price}    ${down_payment_percent}    ${tenor_years}
    
    Wait Until Element Is Visible    ${BANK_PRICE_SLIDER}    timeout=10s
    Scroll Element Into View         ${BANK_PRICE_SLIDER}
    Execute Javascript               window.scrollBy(0, -200)
    Sleep    1s
    
    Wait Until Page Contains Element    ${TENOR_RADIO_BTN}      timeout=5s
    ${radio_btn}=    Get WebElement     ${TENOR_RADIO_BTN}
    Execute Javascript                  arguments[0].click();    ARGUMENTS    ${radio_btn}
    Sleep    1s
    
    ${dropdown_box}=  Get WebElement    ${TENOR_DROPDOWN_BOX}
    Execute Javascript                  arguments[0].click();    ARGUMENTS    ${dropdown_box}
    Sleep    1s
    
    Wait Until Page Contains Element    xpath=//li[contains(text(), '${tenor_years} Year')]    timeout=5s
    ${list_item}=     Get WebElement    xpath=//li[contains(text(), '${tenor_years} Year')]
    Execute Javascript                  arguments[0].click();    ARGUMENTS    ${list_item}
    Sleep    1s
    
    Execute Javascript    let price = document.querySelectorAll("input[type='range']")[0]; if(price) { price.value = '${property_price}'; price.dispatchEvent(new Event('input', { bubbles: true })); price.dispatchEvent(new Event('change', { bubbles: true })); }
    Execute Javascript    let dp = document.querySelectorAll("input[type='range']")[1]; if(dp) { dp.value = '${down_payment_percent}'; dp.dispatchEvent(new Event('input', { bubbles: true })); dp.dispatchEvent(new Event('change', { bubbles: true })); }
    
    Capture Page Screenshot      ${OUTPUT_DIR}/${TEST NAME}_inputs_entered.png
    
    ${show_btn}=      Get WebElement    ${SHOW_RESULTS_BTN}
    Execute Javascript                  arguments[0].click();    ARGUMENTS    ${show_btn}

# ==========================================
# KEYWORDS FOR BY BUDGET
# ==========================================
Calculate Top Bank Picks Based On Budget
    [Arguments]    ${property_price}    ${down_payment_percent}    ${monthly_budget}
    
    Wait Until Element Is Visible    ${BANK_PRICE_SLIDER}    timeout=10s
    Scroll Element Into View         ${BANK_PRICE_SLIDER}
    Execute Javascript               window.scrollBy(0, -200)
    Sleep    1s
    
    Wait Until Page Contains Element    ${BUDGET_RADIO_BTN}      timeout=5s
    ${radio_btn}=    Get WebElement     ${BUDGET_RADIO_BTN}
    Execute Javascript                  arguments[0].click();    ARGUMENTS    ${radio_btn}
    Sleep    1s
    
    Wait Until Element Is Visible    ${BUDGET_INPUT_FIELD}    timeout=5s
    Click Element                    ${BUDGET_INPUT_FIELD}
    Press Keys                       ${BUDGET_INPUT_FIELD}    CTRL+a+BACKSPACE
    Press Keys                       ${BUDGET_INPUT_FIELD}    ${monthly_budget}
    Sleep    1s
    
    Execute Javascript    let price = document.querySelectorAll("input[type='range']")[0]; if(price) { price.value = '${property_price}'; price.dispatchEvent(new Event('input', { bubbles: true })); price.dispatchEvent(new Event('change', { bubbles: true })); }
    Execute Javascript    let dp = document.querySelectorAll("input[type='range']")[1]; if(dp) { dp.value = '${down_payment_percent}'; dp.dispatchEvent(new Event('input', { bubbles: true })); dp.dispatchEvent(new Event('change', { bubbles: true })); }
    
    Capture Page Screenshot      ${OUTPUT_DIR}/${TEST NAME}_budget_inputs_entered.png
    
    ${show_btn}=      Get WebElement    ${SHOW_RESULTS_BTN}
    Execute Javascript                  arguments[0].click();    ARGUMENTS    ${show_btn}