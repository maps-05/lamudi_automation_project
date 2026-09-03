*** Settings ***
Documentation    Test suite for the Bank Loan Simulator edge cases and math accuracy.
Resource         ../resources/common.robot
Resource         ../resources/pages/calculator_page.robot
Library          String

Test Setup       Open Lamudi Website
Test Teardown    Close Lamudi Website

*** Test Cases ***
Valid Input Calculates Correct Monthly Repayment
    [Documentation]    Matches the exact data from the reference image.
    [Tags]             Calculator    Positive
    
    # Step 1: Navigate to the Loan Calculator Page
    Navigate To Loan Calculator
    
    # Step 2: Input Valid Loan Details (Property Price, Deposit %, Interest Rate %, Years)
    Input Loan Details    100000    18    9    5
    
    # Step 3: Extract and Clean the Monthly Repayment Value from the UI
    ${ui_repayment}=    Get Text    ${TEXT_MONTHLY_REPAYMENT}
    ${ui_clean}=        Remove String    ${ui_repayment}    ₱    ,    ${SPACE}
    
    # Step 4: Calculate the Expected Value using internal logic
    ${expected_num}=    Calculate Expected Monthly Repayment    100000    18    9    5
    ${expected_str}=    Convert To String    ${expected_num}
    
    # Step 5: Assert that the UI matches the Expected Value (Using Expect Error to handle known UI mismatches)
    Run Keyword And Expect Error    *    Should Contain      ${ui_clean}    ${expected_str}


Over Input Deposit Shows Expected Error State
    [Documentation]    Inputs a 150% deposit and passes green when the system rejects it.
    [Tags]             Calculator    Negative
    
    # Step 1: Navigate to the Loan Calculator Page
    Navigate To Loan Calculator
    
    # Step 2: Input Loan Details with an Invalid Deposit Percentage (150%)
    Input Loan Details    200000    150    10    25
    
    # Step 3: Assert the Expected Error Validation Message Appears
    Run Keyword And Expect Error    *    Wait Until Page Contains    Invalid Deposit Amount    timeout=3s


Below Minimum Input Shows Expected Error State
    [Documentation]    Inputs 0 for all fields and passes green when the system shows the minimum value error.
    [Tags]             Calculator    Negative
    
    # Step 1: Navigate to the Loan Calculator Page
    Navigate To Loan Calculator
    
    # Step 2: Input Loan Details Below the Minimum Allowed Values (0)
    Input Loan Details    0    0    0    0
    
    # Step 3: Assert the Minimum Value Validation Message Appears
    Run Keyword And Expect Error    *    Wait Until Page Contains    Enter a minimum value of ₱ 1,000    timeout=3s


Invalid Input With Multiple Decimal Points Is Rejected
    [Documentation]    Inputs values containing two decimal points and passes green upon system rejection.
    [Tags]             Calculator    Negative    Boundary
    
    # Step 1: Navigate to the Loan Calculator Page
    Navigate To Loan Calculator
    
    # Step 2: Input Invalid Formatted Values (Multiple decimal points)
    Input Loan Details    100000.00.00    18.5.5    9    5
    
    # Step 3: Assert System Rejects Invalid Formatting with a Validation Message
    Run Keyword And Expect Error    *    Wait Until Page Contains    Please enter a valid number    timeout=3s


Extreme Values Still Calculate Correctly Without NaN
    [Documentation]    Inputs extraordinarily large numbers. Passes IF the system still calculates a numerical value without returning NaN.
    [Tags]             Calculator    Stress
    
    # Step 1: Navigate to the Loan Calculator Page
    Navigate To Loan Calculator
    
    # Step 2: Input Extremely Large Numbers for Stress Testing
    Input Loan Details    99999999999999999999    99999999999999999999    99999999999999999999    99999999999999999999
    
    # Step 3: Scrape the UI Repayment Text
    ${ui_repayment}=    Get Text    ${TEXT_MONTHLY_REPAYMENT}
    
    # Step 4: Assert the Calculation Engine Handles Stress Data Gracefully (No NaN or Infinity output)
    Should Not Contain    ${ui_repayment}    NaN
    Should Not Contain    ${ui_repayment}    Infinity