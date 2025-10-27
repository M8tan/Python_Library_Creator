Prerequisetes -
python {including pip} and the "build" package {you can run pip install build to make sure you have it, Library_Creator will check if it's installed and attempt to install it if not}.

To generate a fresh library template:
run app.exe
enter the directory in which you want to create it, the name and a short description, then press create.
for example, if you want to create a library called pytestpybest in the directory c:\Projects -
directory - c:\Projects
name - pytestpybest
description - a library to test python code
and create.
when the program let's you know that it's done, you can go to c:\Projects\pytestpybest\pytestpybest
and edit the pytestpybest.py file, which holds the library functions and variables.
once you're done building the py file, you can build the library!

To build a library:
run app.exe
enter the root directory of your library {in this case - c:\Projects\pytestpybest} and press build {it takes like 15 seconds so be patiant}.
it will build and install the library based on the pyproject.toml file, so modify it if necessary but make sure it's correct, the Create function generates a valid one.
now you can import and use your library!

note:
the function autocomplete is only available after using the "Build" function. "Editable build" won't allow it 
