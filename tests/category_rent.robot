*** Settings ***
Documentation    Test suite demonstrating Top Menu navigation and AI validation for House & Lot properties.
Resource         ../resources/common.robot
Resource         ../resources/pages/home_page.robot
Resource         ../resources/pages/results_page.robot

Test Setup       Open Lamudi Website
Test Teardown    Close Lamudi Website

*** Variables ***
${MIN_BUDGET}       1
${MAX_BUDGET}       50000000
${TARGET_VIBE}      Urban Professional

*** Test Cases ***
User Can Navigate To Apartments For Rent Category And Validate Listings
    [Documentation]    Navigates via the Rent dropdown menu, validates UI state, 
    ...                checks monthly prices using Python, and uses AI to validate the vibe.
    [Tags]             Navigation    Rentals

    # Step 1: Navigate via Top Menu Dropdown
    Hover Over Rent Menu
    Select Apartments For Rent

    # Step 2: Validate UI State on Results Page
    Verify Property Type Filter Is Set To    Apartment For Rent
    
    # Step 3: Validate Complex Data
    Run Keyword And Continue On Failure    Validate Displayed Prices Are Within Range    ${MIN_BUDGET}    ${MAX_BUDGET}
    
    # Step 4: AI Validation (Custom Tool)
    Validate First Listing Matches Vibe Using AI      ${TARGET_VIBE}