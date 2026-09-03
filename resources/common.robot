*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BROWSER}      Chrome
${BASE_URL}     https://www.lamudi.com.ph/

*** Keywords ***
Open Lamudi Website
  
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait    10 seconds

Close Lamudi Website
    Close All Browsers