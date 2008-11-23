EditableDetailView

Modeled loosely on the Contacts application, EditableDetailView shows how to use UITableView's APIs for inserting and deleting rows, editable content within table cells, and use of a UITableView to select an option from a predefined list. The sample also demonstrate use of the cell reordering APIs, including how to disallow movement on a per-cell basis, propose alternative destinations for any movement, and appropriate updates to the underlying model object graph. 

Rather than address book contacts, the content for the application is a simple menu, allowing the user to specify main courses, beverages, and desserts. In addition, the application shows how to use a property list ("plist") as the underlying data store for editable hierarchical data. The default data is bundled with the application. At launch time, the application checks for the existence of the data in the Documents folder and if it is not present, copies the default data to that location. User edits are then saved to that location.

Build Requirements
Mac OS X 10.5.3, Xcode 3.1, iPhone OS 2.0.

Runtime Requirements
Mac OS X 10.5.3, iPhone OS 2.0.

Packaging List
main.m
Launches the application and specifies the class name for the application delegate.

AppDelegate
Application delegate. Manages the object graph of data that is the "model" part of the app's MVC design.

DetailViewController
Main view controller for the app. Displays a grouped table view and manages edits to the table, including add, delete, reorder, and navigation to edit the contents of individual items.
 
DetailCell
Custom table cell used in the main view's table. Capable of displaying in two modes - a "type:name" mode for existing data and a "prompt" mode when used as a placeholder for data creation.
 
EditingViewController
View controller for editing the content of a specific item.

EditableCell
Custom table cell used in the editing view's table. Contains a UITextField for in-place editing of content.

TypeListController
View controller for changing the type of a specific item. Displays a list of types with a check-mark accessory view indicating the designated row. Selection of a row changes the type and navigates back to the previous view.


Changes from Previous Versions
1.1 Changed "desert" to "dessert" (spelling correction).

Copyright (C) 2008 Apple Inc. All rights reserved.
