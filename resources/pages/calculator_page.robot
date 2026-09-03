*** Settings ***
Library    SeleniumLibrary
Library    Collections    
Library    ../../libraries/RealEstateHelper.py

*** Variables ***
${NAV_RESOURCES}           xpath=//button[contains(@class, 'nav-link') and contains(normalize-space(), 'Resources')]
${NAV_LOAN_CALC}           xpath=//a[@href='/loan-calculator/' and @data-test='nav-link']

${INPUT_PRICE}             xpath=//*[@data-test='mortgage-configurator-amount']
${INPUT_DEPOSIT}           xpath=//wl-range-slider[@data-test='mortgage-configurator-opening']
${INPUT_TERM}              xpath=//wl-range-slider[@data-test='mortgage-configurator-years']
${INPUT_INTEREST}          xpath=//wl-range-slider[@data-test='mortgage-configurator-interest']

${TEXT_MONTHLY_REPAYMENT}  xpath=//span[@data-test='mortgage-details-monthly']
${PIE_CHART_ELEMENT}       xpath=//canvas[@data-test='mortgage-details-chart']


*** Keywords ***
Navigate To Loan Calculator
    Wait Until Element Is Visible    ${NAV_RESOURCES}    timeout=10s
    Mouse Over    ${NAV_RESOURCES}
    Sleep    1s
    Wait Until Element Is Visible    ${NAV_LOAN_CALC}    timeout=10s
    Capture Page Screenshot          ${OUTPUT_DIR}/${TEST NAME}_resources_menu_expanded.png
    
    Click Element    ${NAV_LOAN_CALC}


Input Loan Details
    [Arguments]    ${price}    ${deposit}    ${term}    ${interest}
    
    Wait Until Element Is Visible    ${INPUT_PRICE}    timeout=10s
    Scroll Element Into View         ${INPUT_PRICE}
    Sleep    1s
    
    Capture Page Screenshot          ${OUTPUT_DIR}/${TEST NAME}_calculator_scrolled_into_view.png
    
    Click Element    ${INPUT_PRICE}
    Press Keys       ${INPUT_PRICE}    CTRL+a+BACKSPACE
    Press Keys       ${INPUT_PRICE}    ${price}
    
    Execute Javascript    let el1 = document.querySelector("wl-range-slider[data-test='mortgage-configurator-opening']"); el1.value = '${deposit}'; el1.dispatchEvent(new Event('input', { bubbles: true })); el1.dispatchEvent(new Event('change', { bubbles: true }));
    
    Execute Javascript    let el2 = document.querySelector("wl-range-slider[data-test='mortgage-configurator-years']"); el2.value = '${term}'; el2.dispatchEvent(new Event('input', { bubbles: true })); el2.dispatchEvent(new Event('change', { bubbles: true }));
    
    Execute Javascript    let el3 = document.querySelector("wl-range-slider[data-test='mortgage-configurator-interest']"); el3.value = '${interest}'; el3.dispatchEvent(new Event('input', { bubbles: true })); el3.dispatchEvent(new Event('change', { bubbles: true }));
    
    Sleep    1.5s
    
    Capture Page Screenshot          ${OUTPUT_DIR}/${TEST NAME}_calculator_values_entered.png