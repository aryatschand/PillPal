# PillPal

## Inspiration

In America, the drug abuse issue is only growing in severity. The Pill Pal looks to help drug consumers manage and consume their drugs safely and in appropriate amounts. A group member's aunt is a nurse and deals with patients all the time. A common issue that arises with patients living at home is when patients need to get pills and don't know which ones to take. Instead of setting up an appointment which can take multiple business days to work, patients can quickly interact with doctors through their own pill dispensers at home using Pill Pal's WiFi-compatible app.

## What it does

When it is time for a patient to take their pills, they can quickly reach out to their doctor for permission to take the pill. Using the Pill Pal app, the patient can send a pill request to the doctor's phone Pill Pal app via a WiFi connection on the patient's Pill Pal app. The app allows the doctor to decide whether the patient should or shouldn't take the specific requested medications. After approving of the pill request, the dispenser will automatically shuffle to the correct pill, only allowing access to the doctor-approved pill. This will be followed by a label that displays the name of the patient and the pill type.

## How we built it

The creation of Pill Pal was comprised of three main parts. The first part is the creation of the Pill Pal app itself. The app was created through Swift

Hardware:
First we wired all the components which included the servo motor, LCD, LED indicator , and the WiFi module. After wiring was all correct and the circuit was complete the next step was to program the hardware. Initially we wanted to make sure each component can work independently before putting it all together, so we made sure that was working. Once we knew that everything worked by itself we programmed the WiFi module to wait for a connection and once the connection was received we began the process of dispensing a pill.

The final part was the construction of the actual dispenser itself. As a prototype, it was constructed our of primarily cardboard and hot glue. Seven mini-containers were created as well as the spinning-table disk that was attached to a motor. This motor allows for the entire contraption to spin to the correct pill, while a large cover with a small opening was placed on top to prevent access to the unapproved pills.

## Challenges we ran into

The biggest problem that occurred during the project was related to the arduino. Midway into the project, the entire circuit began to overheat and eventually short circuited. This led us to restart the circuit on a separate arduino using a servo motor instead. A really strange problem occurred while developing the app through Swift. For some reason, the buttons on the app were unresponsive. We had never seen this seemingly basic issue cause the app to malfunction in this way before. This ended up being a huge obstacle as the entire app failed to operate correctly for a while.

## Accomplishments that we're proud of

The aspects of the project that we were most proud of are the ones regarding the challenges we had to overcome. A big obstacle was tackling the WiFi connection from the arduino to the phone app. We also spent a lot of time accurately measuring the values required for the servo motor to turn the dispenser to the precise angle. We managed to incorporate the ultrasonic sensor and relay that information back to the app. In terms of coding the app, we already mentioned how we ran into a bizarre coding challenge when the buttons of the app didn't seem to work. After playing around with the code, we managed to return it to a functioning state, which was a significant accomplishment because of how long it took. Also, we had to construct the actual dispenser, measuring the side lengths to ensure even proportions for the servo motor to balance the contraption.

## What's next for Pill Pal
In the future, we would like to incorporate radio-frequency identification (RFID) to allow doctors to identify their patients through unique RFID tags. This can help doctors determine exactly which pills can go to which patients. Another identification method can be using fingerprint sensors. With medicine, security is extremely important to ensure that patients receive the correct medicine with the right dosage. Another feature that can be implemented is a way for the pill to actually be dispensed. This way, patients with Alzheimer's don't have to endure the inconvenience of actually reaching in and taking the pill. Also, a 360 degree motor would be more useful than a servo motor, which we had to use to overcome the short circuit mentioned in the challenges section. One last feature we could add is a way for the dispenser to send more than one pill and dispense the exact amount the patient needs.
