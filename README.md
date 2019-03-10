# Undeaf
## Goal:
We aim to offer deaf people the best communication experience. We help them to express their ideas to the whole world with our app. Thanks to our project they are able to talk to anybody with ease. The app uses AI to tranlsate the sign language gesture into a voice that allows any interlocutor to easily understand what the user tries to say. Finally the answer of the interlocutor is converted to text that the user can read. This completes a conversation between two people that could not easily speak to each other in the past.

## Demo:

<figure>
  <img alt="portfolio_view" src="https://j.gifs.com/5Q94EB.gif" title="thedescription.html">
  <figcaption>On this small video we can see the text to sign translation that can be used to help the deaf person to hear his/her interlocutor.</figcaption>
</figure>


## Repository Structure:
You can find our trained model in the \ml-model folder in both .pb and .mlmodel format. In the case you want to train your own model with Tensorflow, you can find in the same folder a way to convert a model saved in .pb file to a .mlmodel file. To use it you will have to clone the following repo

```shell
git clone git@github.com:tf-coreml/tf-coreml.git
```
The model in .mlmodel format must be located at 
```shell
Undeaf/Starthack19/Starthack19/
```

In the same folder you can find some other utility scripts to generate your dataset.

The Starthack2019 folder contains the code for the iOS app.

## External library:
To recognize sign language alphabet we used Loïc Marie's code that you can find on his GitHub repo at:

https://github.com/loicmarie/sign-language-alphabet-recognizer

