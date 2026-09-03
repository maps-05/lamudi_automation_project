*** Settings ***

Library    SeleniumLibrary
Library    Collections    
Library    ../../libraries/RealEstateHelper.py

*** Variables ***
# ==========================================
# LOCATORS FOR SEARCH PROPERTIES
# ==========================================
${RESULTS_HEADER}       xpath=//h1[contains(@class, 'title-section__title')]
${LISTING_PRICES}       xpath=//div[contains(@class, 'snippet__content__price')]
${FIRST_LISTING_DESC}   xpath=(//div[contains(@class, 'snippet__content__description')])[1]

# ==========================================
# LOCATORS FOR CATEGORY BUY
# ==========================================
${PROPERTY_TYPE_RESULT}    xpath=//h1[@class='title-section__title']


*** Keywords ***
# ==========================================
# KEYWORDS FOR SEARCH PROPERTIES
# ==========================================

Verify Search Results Are Displayed For Location

    [Arguments]    ${location_name}
    Wait Until Element Is Visible    ${RESULTS_HEADER}
    Element Should Contain           ${RESULTS_HEADER}    ${location_name}    ignore_case=True
    Capture Page Screenshot          ${OUTPUT_DIR}/${TEST NAME}_search_results_header_verified.png

# ==========================================
# KEYWORDS FOR BOTH CATEGORY BUY AND RENT
# ==========================================

Validate First Listing Matches Vibe Using AI

    [Arguments]    ${expected_vibe}
    Wait Until Element Is Visible    ${FIRST_LISTING_DESC}

    Capture Page Screenshot          ${OUTPUT_DIR}/${TEST NAME}_first_listing_description_captured.png

    ${description}=    Get Text      ${FIRST_LISTING_DESC}
    ${is_match}=    Ai Validate Listing Vibe    ${description}    ${expected_vibe}

    Should Be True    ${is_match}

# ==========================================
# KEYWORDS FOR CATEGORY BUY
# ==========================================
Verify Property Type Filter Is Set To

    [Arguments]    ${expected_property_type}

    [Documentation]    Validates the main page header matches the selected category instead of the dropdown filter.

    Wait Until Element Is Visible    ${PROPERTY_TYPE_RESULT}    timeout=10s

    Element Should Contain    ${PROPERTY_TYPE_RESULT}    ${expected_property_type}    ignore_case=True
    Capture Page Screenshot          ${OUTPUT_DIR}/${TEST NAME}_property_type_filter_verified.png


Validate All Displayed Prices Are Below Budget

    [Arguments]    ${max_budget}

    @{price_elements}=    Get WebElements    ${LISTING_PRICES}
    Capture Page Screenshot          ${OUTPUT_DIR}/${TEST NAME}_prices_displayed_for_budget_check.png

    @{price_strings}=     Create List
    FOR    ${element}    IN    @{price_elements}
        ${text}=    Get Text    ${element}
        Append To List    ${price_strings}    ${text}
    END

    Validate Prices Are Within Budget    ${price_strings}    ${max_budget}

# ==========================================
# KEYWORDS FOR CATEGORY RENT
# ==========================================
Validate Displayed Prices Are Within Range

    [Arguments]    ${min_budget}    ${max_budget}
    [Documentation]    Scrapes all prices from the page and passes them to the Python range validator.

    @{price_elements}=    Get WebElements    ${LISTING_PRICES}

    Capture Page Screenshot          ${OUTPUT_DIR}/${TEST NAME}_prices_displayed_for_range_check.png
    @{price_strings}=     Create List

    FOR    ${element}    IN    @{price_elements}
        ${text}=    Get Text    ${element}
        Append To List    ${price_strings}    ${text}
    END

    Validate Prices Are Within Range    ${price_strings}    ${min_budget}    ${max_budget} 

