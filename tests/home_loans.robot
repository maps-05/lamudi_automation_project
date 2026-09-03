*** Settings ***
Documentation    Test suite for the Home Loans section and Top Bank Picks functionality.
Resource         ../resources/common.robot
Resource         ../resources/pages/home_loans_page.robot

Test Setup       Open Lamudi Website
Test Teardown    Close Lamudi Website

*** Test Cases ***
Top Bank Picks Display Correct Providers Based On Input
    [Documentation]    Adjusts the price and DP sliders on the Home Loans page using Tenor and verifies the 3 specific banks.
    [Tags]             Home_Loans    Tenor_Flow    Positive
    
    # Step 1: Navigate to the Home Loans Page
    Navigate To Home Loans Page
    
    # Step 2: Input Financial Data Using Tenor Flow (Price, DP %, Tenor Years)
    Calculate Top Bank Picks Based On Tenor   122800000    40    10
    
    # Step 3: Wait for Backend API Response and Capture Visual Evidence
    Sleep    3s
    Wait Until Element Is Visible    ${BANK_RESULTS_CARDS}    timeout=10s
    Capture Page Screenshot    ${OUTPUT_DIR}/${TEST NAME}_banks_displayed.png

    # Step 4: Strict Assertion of Rendered Bank Cards (Ensuring they are visible elements)
    Page Should Contain Element    xpath=//h3[contains(normalize-space(), 'Our Top Bank Picks')]/..//p[normalize-space()='Metrobank']
    Page Should Contain Element    xpath=//h3[contains(normalize-space(), 'Our Top Bank Picks')]/..//p[normalize-space()='RCBC']
    Page Should Contain Element    xpath=//h3[contains(normalize-space(), 'Our Top Bank Picks')]/..//p[normalize-space()='HSBC PH']


Top Bank Picks Display Correct Providers Based On Budget
    [Documentation]    Selects "Based on Budget", inputs financial constraints, and verifies the banks.
    [Tags]             Home_Loans    Budget_Flow    Positive
    
    # Step 1: Navigate to the Home Loans Page
    Navigate To Home Loans Page
    
    # Step 2: Input Financial Constraints Using Budget Flow (Price, DP %, Monthly Budget)
    Calculate Top Bank Picks Based On Budget    150400000    55    500000
    
    # Step 3: Wait for Backend API Response and Capture Visual Evidence
    Sleep    3s
    Wait Until Element Is Visible    ${BANK_RESULTS_CARDS}    timeout=10s
    Capture Page Screenshot    ${OUTPUT_DIR}/${TEST NAME}_banks_displayed.png
    
    # Step 4: Strict Assertion of Rendered Bank Cards (Ensuring they are visible elements)
    Page Should Contain Element    xpath=//h3[contains(normalize-space(), 'Our Top Bank Picks')]/..//p[normalize-space()='Metrobank']
    Page Should Contain Element    xpath=//h3[contains(normalize-space(), 'Our Top Bank Picks')]/..//p[normalize-space()='RCBC']
    Page Should Contain Element    xpath=//h3[contains(normalize-space(), 'Our Top Bank Picks')]/..//p[normalize-space()='HSBC PH']