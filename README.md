# Undeaf
## Goal:
We aim to offer deaf people the best communication experience. We help them to express their ideas to the whole world with our app. Thanks to our project they are able to talk to anybody with ease. The app uses AI to tranlsate the sign language gesture into a voice that allows any interlocutor to easily understand what the user tries to say. Finally the answer of the interlocutor is converted to text that the user can read. This completes a conversation between two people that could not easily speak to each other in the past.

## Repository Structure:
You can find our trained model in the \ml-model folder in both .pb and .mlmodel format. In the case you want to train your own model with Tensorflow, you can find in the same folder a way to convert a model saved in .pb file to a .mlmodel file. To use it you will have to clone the following repo

```shell
git clone git@github.com:tf-coreml/tf-coreml.git
```
The model in .mlmodel format must be located at 
```shell
Undeaf/Starthack19/Starthack19/
```

## External library:
To recognize sign language alphabet we used Loic Marie's code that you can find on his GitGub repo at:

https://github.com/loicmarie/sign-language-alphabet-recognizer
