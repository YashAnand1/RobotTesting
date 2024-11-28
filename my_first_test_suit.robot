*** Settings ***
Library           SeleniumLibrary
# for opening daily update text file
Library           OperatingSystem
Library           DateTime

*** Variables ***
${URL}                     http://pems.keenable.io:3000/login
${USERNAME}                yash.anand@fosteringlinux.com
${PASSWORD}                
${DSR_FILE}                27-11-2024.txt

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
    Click Link                     xpath=//a[text()='MTA']    
    Click Link                     Emp-tracker-2
    Log                            Successfully navigated to the project.

# Not working as expected...
Creating New Issue
#   Wait Until Element Is Visible  xpath=//a[text()='New issue']  
    # Click Button          New issue
    Click Element   xpath=//a[contains(@class, 'icon icon-add new-issue')]
    Log                    New Issue page opened

Adding Subject
    Wait Until Element Is Visible  id=issue_subject  
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
   Wait Until Element Is Visible  id=issue_status_id  
    Click Element            xpath=//option[contains(.,'Inprogress')]
   Log                        Set issue status to In Progress.

# https://stackoverflow.com/questions/46476894/robot-framework-selecting-value-from-a-dropdown-list-which-appears-after-mouse

Assigning To Self
    # Wait Until Element Is Visible      xpath=//a[contains(@class, 'assign-to-me-link')]  
    Click Element            xpath=//option[contains(., '<< me >>')]
    # Click Element                          xpath=//label[contains(text(), 'Assign to me')] 
    Log                                Assigned issue to self.

Adding Due Date
    Input Text  id=issue_due_date  id=issue_start_date  # Set the same value to the issue_due_date field
    Log        Set due date to


Selecting Type of Work
    Wait Until Element Is Visible  id=issue_custom_field_values_32
    Click Element          xpath=//option[contains(.,'Task')]
    Log                        Selected type of work: Task.

Submitting Issue
    Wait Until Element Is Visible  xpath=//input[@name='commit']  
    Click Button           xpath=//input[@name='commit']
    Log                    Issue successfully created.

Adding Work Location
    # Input Text             id=radio  DSR Update
    Click Element          xpath=//option[contains(.,'Working FROM Office')]
    Log                    selected work location as Offices

# TO DO : Assigned by, Due Date, Type of Work, click Submit 

Close Browser
    Close Browser
    Log                     Closed the browser