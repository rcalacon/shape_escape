Project Name: Shape Escape
Description:
Shape Escape provides a series of mini games for the user to play. Each mini game visualizes shapes (circles and squares, depending on the game). Rules are different for every game. Shape Escape leverages the Painter, Canvas and Animation classes heavily for each game.

Games:
Appear: Tap the square once you can see it. The goal is to tap all squares (5 total) in the shortest amount of time. A penalty is given for missed taps, removing any possibility of the user spamming taps on the screen to cheat. This game takes advantage of the opacity property of the Paint class.
React: Similar to appear, tap the square once you see it. In this case, you will always see it. The difference is that one the user taps the square, the square will immediately move to another location. Unlike Appear, this game tracks how many times the user clicks the square successfully. Penalties are also given here for missed taps to avoid cheating. A successful tap increases the score by one. A failed tap decreases the score by one.
Count: Count how many items are on the screen (squares and circles). Instead of directly clicking on the shapes, 5 possible answers are provided to you in the form of buttons. It is up to the user to count as quickly as possible to determine the correct answer. Score is measured by how much time it takes to get past all the levels. Penalties are given for incorrect answers so that the user cannot simply spam all of the answers per level.
Unique: Determine which shape is not like any of the others. Similar to the count game, the user is presented possible answers at the very bottom of the screen. Like the count game, score is determined by how long it takes for you to get past all of the levels. Also like the count game, penalties are given for incorrect answers to prevent the user from spamming.
Stack: Try to stack as many rectangles (up to 8) as possible, as perfectly as possible. A button is provided to the user to "stack" the currently moving rectangle such that it is directly on top of the one right below it. Each successful stack is 10 points. Extra points are provided based on how perfect the stacking was.
There is also a workflow to submit scores and read high scores. Users can submit high scores by providing initials (does not have to be unique) once a mini game is complete. There is a high scores page to see the top 10 scores per game. A user can possibly do well in a game, provide initials and see if he/she made the top list shortly afterwards.

Special Instructions
Target Environment: Similar to previous assignments, Pixel API 29. This is important because I had to hard code the canvas dimensions for each mini game due to time constraints. Something I plan to do in the future is to calculate these dimensions dynamically for better cross platform portability.

Orientation: To keep the project simple, I forced each view to stay in portrait mode. I tested this by unlocking orientation changes within the emulator and rotating the phone.

Third Party Libraries
All third party libraries are defined in the pubspec.yaml file, so the dependencies should resolve themselves when building the project (assuming using Android Studio). Aside from the flutterfire library, I have also included a custom toast, a custom logo and a google font (again, all defined in pubspec.yaml).

Known Issues
Unique Game: A small issue that might be occurring happens in the last level of the "Unique" game. Sometimes there is no unique shape, at least from what I see. The intent of the last level is to have 5 shapes. 2 shapes are the same size. 2 other shapes are the same size. There is one shape that should not be sized like the other four shapes. This game had the most amount of "randomness" resulting in the most complexity. It is apparent in the painter class.

Count Game: There may be a slight delay in the later levels of the "Count" game. This game has the most complex algorithm because there is a loop to continue looking for an "open space" on the canvas per shape to draw. This can get expensive very quickly, depending on how big the canvas, the number of shapes to draw and the size of them. I do believe I have manipulated those variables enough such that it is fast enough, but just wanted to disclose this information just in case.
