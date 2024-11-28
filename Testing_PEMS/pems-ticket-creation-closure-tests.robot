*** Settings ***
Library           SeleniumLibrary
# for opening daily update text file
Library           OperatingSystem

*** Variables ***
${URL}                     http://pems.keenable.io:3000/login
${USERNAME}                yash.anand@fosteringlinux.com
${PASSWORD}                [ R E D A C T E D ]
${DSR_FILE}                DSR.txt

*** Test Cases ***
Login to Redmine
    Open Browser           ${URL}           Chrome
    Input Text             id=username      ${USERNAME}
    Input Text             id=password      ${PASSWORD}
    
    ###################################
    # IMPORTANT ==> CSS Select vs Xpath 
    ###################################

    # https://medium.com/@sasiwara.boon/using-xpath-in-robot-framework-61511408df4c#:~:text=Robot%20Framework%20is%20an%20open,nodes%20in%20an%20XML%20document.
    Click Button           xpath=//input[@name='login']
    Log                    Successfully logged in.

Selecting Project
    # some elements like PROJECTS are interactable but some like MTA are not - Still need to properly understand WHY 
    Click Link                     Projects 
    # if xpath not used like in article, failed here due to [ElementNotInteractableException: Message: element not interactable]
    Click Link                     xpath=//a[text()='IMS (Inventory)']    
    Click Link                     Emp-tracker-2
    Log                            Successfully navigated to the project.

Creating New Issue
#   Wait Until Element Is Visible  xpath=//a[text()='New issue']  
    # Click Button          New issue
    Click Element   xpath=//a[contains(@class, 'icon icon-add new-issue')]
    Log                    New Issue page opened

Adding Subject
    Input Text             id=issue_subject  DSR Update
    Log                    subject added "DSR Update"

Adding Descriptiona
# from documentation: Returns the contents of a specified file.
# --- > This keyword reads the specified file and returns the contents. Line breaks in content are converted to platform independent form. See also Get Binary File.
# stackoverflow post helped learn about OperatingSystem lib---> https://stackoverflow.com/questions/36637570/get-file-txt-or-csv-in-robot-framework
    ${dsr_content}=        Get File          ${DSR_FILE}
    Input Text             id=issue_description  ${dsr_content}
    Log                    Added desc from dsr

# Is to be done with https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html#Select%20From%20List%20By%20Label
Selecting Status
#    Wait Until Element Is Visible  id=issue_status_id  
    Click Element            xpath=//option[contains(.,'Inprogress')]
    Log                        Set issue status to In Progress.

# https://stackoverflow.com/questions/46476894/robot-framework-selecting-value-from-a-dropdown-list-which-appears-after-mouse

Assigning To Self
    # Wait Until Element Is Visible      xpath=//a[contains(@class, 'assign-to-me-link')]  
    Click Element            xpath=//option[contains(., '<< me >>')]
    # Click Element                          xpath=//label[contains(text(), 'Assign to me')] 
    Log                                Assigned issue to self.

# Adding Due Date
#     Input Text  id=issue_due_date  27-11-2024  # Set the same value to the issue_due_date field
#     Log        Set due date to

Set Due Date Using Input Text
    Wait Until Element Is Visible    id=issue_due_date    2s
    Input Text                       id=issue_due_date    11/28/2024
    Press Key                        id=issue_due_date    TAB
    # Set Browser Implicit Wait        60s
    Log                              'Due date set to 28/11/2024'

Selecting Type of Work
    # Wait Until Element Is Visible  id=issue_custom_field_values_32
    Click Element          xpath=//option[contains(.,'Task')]
    Log                        Selected type of work: Task.

Adding Work Location
    # Input Text             id=radio  DSR Update
    Click Element          xpath=//input[@value='Working FROM Office']
    Log                    selected work location as Offices

Submitting Issue
    # Wait Until Element Is Visible    xpath=//input[@name='commit']    20s
    Click Button                     xpath=//input[@name='commit']
    Log                              Issue successfully created.
    # No Operation
    # Log                              Keeping the browser window open.

Marking issue as Resolved
    Click Element   xpath=//a[text()='Edit']
    Log             successfully clicked 'edit issue' 
    Click Element   xpath=//option[contains(.,'Resolved')]

Submitting Issue Resolved
    # Wait Until Element Is Visible    xpath=//input[@name='commit']    20s
    Click Button                     xpath=//input[@value='Submit']
    Log                              Issue successfully created.

Marking issue as cLosed
    Click Element   xpath=//a[text()='Edit']
    Log             successfully resolved
    Click Element   xpath=//option[contains(.,'Closed')]

Submitting Issue closed
    # Wait Until Element Is Visible    xpath=//input[@name='commit']    20s
    Click Button                     xpath=//input[@value='Submit']
    Log                              Issue successfully created.

# TO DO : Assigned by, Due Date, Type of Work, click Submit 
Close Browser
    Log                     Closed the browser
