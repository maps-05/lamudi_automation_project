*** Settings ***
Documentation    Test suite demonstrating Top Menu navigation and AI validation for House & Lot properties.
Resource         ../resources/common.robot
Resource         ../resources/pages/home_page.robot
Resource         ../resources/pages/results_page.robot

Test Setup       Open Lamudi Website
Test Teardown    Close Lamudi Website

*** Variables ***
${MAX_BUDGET}       15000000
${TARGET_VIBE}      Farm-friendly style

*** Test Cases ***
User Can Navigate To House And Lot Category And Validate Listings
    [Documentation]    Navigates via the Buy dropdown menu, validates UI state, 
    ...                checks prices using Python, and uses AI to validate the listing vibe.
    [Tags]             Navigation    AI_Validation

    # Step 1: Navigate via Top Menu Dropdown
    Hover Over Buy Menu
    Select House And Lot For Sale

    # Step 2: Validate UI State on Results Page
    Verify Property Type Filter Is Set To    House and Lot For Sale
    
    # Step 3: Expect the budget to fail (because properties are more expensive than 15M)
    Run Keyword And Expect Error    *exceeds budget*    Validate All Displayed Prices Are Below Budget    ${MAX_BUDGET}
    
    # Step 4: Expect the AI to fail (because the properties are not farm-friendly)
    Run Keyword And Expect Error    *does NOT match vibe*    Validate First Listing Matches Vibe Using AI      ${TARGET_VIBE}