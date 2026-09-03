*** Settings ***
Documentation    Test suite demonstrating UI automation and Custom Python tools for Lamudi.
Resource         ../resources/common.robot
Resource         ../resources/pages/home_page.robot
Resource         ../resources/pages/results_page.robot

Test Setup       Open Lamudi Website
Test Teardown    Close Lamudi Website

*** Variables ***
# Valid Test Data
${TARGET_LOCATION}    Makati

# Invalid Test Data
${INVALID_LOCATION}   123manila123


*** Test Cases ***
User Can Search For Properties And Validate Data
    [Documentation]    Searches for a valid property location and validates the data.
    [Tags]             Smoke    Search    Positive_Test
    
    # Step 1: Navigate and Search
    Select Buy Option
    Search For Location    ${TARGET_LOCATION}
    Click Search Button
    
    # Step 2: Validate UI State
    Verify Search Results Are Displayed For Location    ${TARGET_LOCATION}


User Experiences Expected Failure On Invalid Search
    [Documentation]    Attempts to search for a gibberish location and expects the UI to time out.
    [Tags]             Search    Negative_Test
    
    # Step 1: Select the Buy toggle
    Select Buy Option
    
    # Step 2: Search with invalid data and EXPECT the 10-second timeout error
    Run Keyword And Expect Error    *not visible after 10 seconds.*    Search For Location    ${INVALID_LOCATION}


User Experiences Expected Failure On Empty Search
    [Documentation]    Attempts to search with no input and expects the UI to time out.
    [Tags]             Search    Negative_Test
    
    # Step 1: Select the Buy toggle
    Select Buy Option
    
    # Step 2: Search with empty data and EXPECT the 10-second timeout error
    Run Keyword And Expect Error    *not visible after 10 seconds.*    Search For Location    ${EMPTY}