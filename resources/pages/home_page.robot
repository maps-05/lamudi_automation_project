*** Settings ***
Library    SeleniumLibrary

*** Variables ***
# ==========================================
# LOCATORS FOR SEARCH PROPERTIES
# ==========================================
${SEARCH_INPUT}         xpath=//input[@data-test='search-bar']
${SEARCH_BUTTON}        xpath=//button[@data-test='search-btn']
${BUY_RENT_TOGGLE}      xpath=//label[@data-test='operationType-label-sell']
${LOCATION_SUGGESTION}  xpath=//div[contains(@class, 'text-suggestion')]

# ==========================================
# LOCATORS FOR CATEGORY BUY
# ==========================================
${TOP_NAV_BUY}                  xpath=//button[contains(@class, 'nav-link') and contains(normalize-space(), 'Buy')]
${HOUSE_AND_LOT_DROPDOWN}       xpath=//a[@href='/buy/house/' and @data-test='nav-link']

# ==========================================
# LOCATORS FOR CATEGORY RENT
# ==========================================
${TOP_NAV_RENT}                 xpath=//button[contains(@class, 'nav-link') and contains(normalize-space(), 'Rent')]
${APARTMENTS_RENT_DROPDOWN}     xpath=//a[@href='/rent/apartment/' and @data-test='nav-link']


*** Keywords ***
# ==========================================
# KEYWORDS FOR SEARCH PROPERTIES
# ==========================================
Select Buy Option
    Wait Until Element Is Visible    ${BUY_RENT_TOGGLE}    timeout=10s
    Click Element                    ${BUY_RENT_TOGGLE}
    
    Capture Page Screenshot          ${OUTPUT_DIR}/${TEST NAME}_buy_toggle_selected.png

Search For Location
    [Arguments]    ${location_name}
    Wait Until Element Is Visible    ${SEARCH_INPUT}    timeout=10s
    Input Text                       ${SEARCH_INPUT}    ${location_name}
    
    Sleep                            2s
    Wait Until Element Is Visible    ${LOCATION_SUGGESTION}    timeout=10s
    
    Capture Page Screenshot          ${OUTPUT_DIR}/${TEST NAME}_location_suggestions_visible.png
    
    Wait Until Keyword Succeeds      3x    2s    Click Element    ${LOCATION_SUGGESTION}

Click Search Button
    Click Element                    ${SEARCH_BUTTON}
    Sleep                            2s
    Capture Page Screenshot          ${OUTPUT_DIR}/${TEST NAME}_search_results_page.png

# ==========================================
# KEYWORDS FOR CATEGORY BUY
# ==========================================
Hover Over Buy Menu
    Wait Until Element Is Visible    ${TOP_NAV_BUY}    timeout=10s
    Mouse Over    ${TOP_NAV_BUY}
    Wait Until Element Is Visible    ${HOUSE_AND_LOT_DROPDOWN}    timeout=5s
    
    Capture Page Screenshot          ${OUTPUT_DIR}/${TEST NAME}_buy_menu_expanded.png

Select House And Lot For Sale
    Click Element    ${HOUSE_AND_LOT_DROPDOWN}


# ==========================================
# KEYWORDS FOR CATEGORY RENT
# ==========================================
Hover Over Rent Menu
    Wait Until Element Is Visible    ${TOP_NAV_RENT}    timeout=10s
    Mouse Over    ${TOP_NAV_RENT}
    Wait Until Element Is Visible    ${APARTMENTS_RENT_DROPDOWN}    timeout=5s
    
    Capture Page Screenshot          ${OUTPUT_DIR}/${TEST NAME}_rent_menu_expanded.png

Select Apartments For Rent
    Click Element    ${APARTMENTS_RENT_DROPDOWN}