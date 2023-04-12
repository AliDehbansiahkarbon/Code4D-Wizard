# Code4D-Wizard - Wizard for Delphi IDE

## What is Code4D-Wizard?

Code4D-Wizard is a set of plugin tools designed to be used in the Delphi IDE. It adds to the Delphi IDE several features to improve our development efficiency, speed and productivity.

# 📞 Contact

<p align="left">
  <a href="https://t.me/Code4DelphiDevs" target="_blank">
    <img src="https://img.shields.io/badge/Telegram:-Join%20Channel-blue">
  </a>
  <!--&nbsp;
  <a href="https://www.youtube.com/@code4delphi" target="_blank">
    <img src="https://img.shields.io/badge/YouTube:-Join%20Channel-red">
  </a> --> 
  &nbsp;
  <a href="mailto:contato@code4delphi.com.br" target="_blank">
    <img src="https://img.shields.io/badge/E--mail-contato%40code4delphi.com.br-yellowgreen">
  </a>  
</p>
<br/>

## ⚙️ Installation

1 - Download C4DWizard.bpl file (Remembering that to use the Wizard, Delphi needs the C4DWizard.bpl file, so save it in a safe folder, with no risk of the file being accidentally deleted)

2 - In your Delphi, access the menu Component > Install Packages...

![Component-InstallPackages.png](https://github.com/Code4Delphi/Code4D-Wizard/blob/master/Img/Component-InstallPackages.png)

3 - Click in button "Add..."

![Form-Install-Packages-Button-ADD.png](https://github.com/Code4Delphi/Code4D-Wizard/blob/master/Img/Form-Install-Packages-Button-ADD.png)

4 - Select the C4DWizard.bpl file

![Package-C4D-Wizard-Installed.png](https://github.com/Code4Delphi/Code4D-Wizard/blob/master/Img/Package-C4D-Wizard-Installed.png)

5- The Code4D item will be added to the IDE's MainMenu

![Code4D-item-added-to-MainMenu.png](https://github.com/Code4Delphi/Code4D-Wizard/blob/master/Img/Code4D-item-added-to-MainMenu.png)

‌

# 🔎 Preview resources Code4D-Wizard
### * Menus add in MainMenu IDE

![Menus-Add-in-MainMenu-IDE-Delphi.png](https://github.com/Code4Delphi/Code4D-Wizard/blob/master/Img/Menus-Add-in-MainMenu-IDE-Delphi.png)

- **Open External Path**: Lets you add items for quick access to resources external to the IDE. How to access files, folders, web links and even CMD commands to perform one or more functions in Windows CMD. Can be configured shortcut keys, and even a logo for each item
  ![Open-External.png](https://github.com/Code4Delphi/Code4D-Wizard/blob/master/Img/Open-External.png)
- **Uses Organization**: Allows you to organize the Uses of the Units, with various configurations, such as the possibility of leaving one Uses per line, sorting uses in alphabetical order, grouping uses by namespaces, breaking lines between namespaces. In addition to making it possible to organize by scope, that is, by the current unit, by open units, project group or project units, and showing a Log with the Units that were orphaned
- **Reopen File History**: Opens a screen, where a history is listed, with all project groups and projects previously opened in the IDE. Enabling the marking of project group or projects as favorites, so that they are shown in prominence. Various information is also presented, such as the date of the last opening and closing, and the possibility of creating a nickname for the item. It is also possible to separate by groups, and search by different filters, including opening dates. On this screen, it is also possible to access various resources of the projects or project group, such as automatically opening the Github Desktop with the project already selected, opening the project in the remote repository, opening the project file in the Windows explorer, among many other resources.
  ![Reopen.png](https://github.com/Code4Delphi/Code4D-Wizard/blob/master/Img/Reopen.png)
- **Translate Text**: Allows texts to be translated between several languages, WITHOUT using any credentials or passwords. If you have any text selected in the IDE's editor at the time the screen is called, the selected text will be loaded onto the screen for translation.
  ![Translate.png](https://github.com/Code4Delphi/Code4D-Wizard/blob/master/Img/Translate.png)
- **Indent Text Selected**: This feature serves to indent the selected code, taking into account some characters, such as := (two equal points), this feature will indent the fonts, aligning the := (two equal points)
- **Find in Files**: Searches the units, with several configuration options, and can search not only in .pas files but also in .dfm, . fmx and in .dpr and .dproj. Another interesting point is that when displaying the search result, it marks the words found in green to make identification easier, in addition to showing a totalizer with the number of occurrences of the searched text and the number of files that have them.
  ![Find-in-files.png](https://github.com/Code4Delphi/Code4D-Wizard/blob/master/Img/Find-in-files.png)

  ![Find-in-files-Messages.png](https://github.com/Code4Delphi/Code4D-Wizard/blob/master/Img/Find-in-files-Messages.png)

- **Replace in Files**: Makes the alteration of texts in the units, with several option of configurations, and it can make the replace not only in .pas files but also in .dfm, . fmx and in .dpr and .dproj. Another interesting point is that when displaying the result of the changes, it shows a totalizer with the number of occurrences of the text changed and the number of files that have them.
- **Default Files In Opening Project**: This feature allows you to inform which units or forms are automatically opened as soon as the project is opened in the IDE.
  ![Default-Files-In-Opening-Project.png](https://github.com/Code4Delphi/Code4D-Wizard/blob/master/Img/Default-Files-In-Opening-Project.png)
- **Settings**: It has some settings related to the Wizard, such as the possibility of informing shortcuts for MainMenu items
- **Backup/Restore Configs**: Allows you to export and import backup files with the Code4D-Wizard settings and data, so when you format your PC you don't ask for your data. In addition to enabling data sharing among other programmers on your team
- **Open in GitHub Desktop**: Allows opening the current project directly on Github Desktop, with the project already open. It is possible to open it in other version management programs, just use the resources available in the Open External Path menu item
- **View in Remote Repository**: Opens the remote repository of the Git project in the browser, it can be GitHub, Bitbucket, GitLab, etc.
- **View Information Remote Repository**: Displays remote repository information of the project
- **View Project File in Explorer**: Opens the current project file in Windows Explorer
- **View Current File in Explorer**: Opens the current file, which is open in the IDE in Windows Explorer
- **View Current Binary in Explorer**: Opens the binary file (.exe) in Windows Explorer, also works for Linux compilation and DLL

‌

### * PopupMenu do Project Manager

![PopupMenu-Project-Manager.png](https://github.com/Code4Delphi/Code4D-Wizard/blob/master/Img/PopupMenu-Project-Manager.png)

‌

### * ToolBars

![ToolBars.png](https://github.com/Code4Delphi/Code4D-Wizard/blob/master/Img/ToolBars.png)

#### **ToolBar Build:**

- Button **Build Project In Release**: Executes the Build of the selected project, with several checks and improvements. Before giving the Build, it checks if the project's .exe is not already open, if it is, it gives a message for it to be closed first. It also automatically changes the project from Debug to Release, and after the Build is finished, it returns to Debug if necessary.
- It is also possible to change the Build Configurations directly through the ComboBox of the ToolBar too, you can change it to Debug or Release

#### **ToolBar Branch:**

- In this ToolBar it is possible to visualize the current Git branch that the project is in. If you are in Branch Master or Main, the text will turn red, alerting the programmer to change the Branch
