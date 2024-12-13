# Bus Route App

A simple app to help users view, search, and manage bus routes. You can search routes by bus number or location, mark your favorite routes, and see details about each route.

## Features Implemented
- **View Bus Routes**: Shows a list of bus routes with the bus number and locations.
- **Search Bus Routes**: You can search for routes by entering either a bus number or a location (from or to).
- **Favorites**: Mark routes as your favorite for easy access later.
- **View Route Details**: Tap on a route to see more information about it.
- **Pagination**: The app loads bus routes in pages to make sure the list doesn’t get too long.
- **Error Handling**: The app shows error messages when something goes wrong, like no routes found or a server error.

## Non-Implemented/Planned Features
- **Map Integration**: I planned to add a feature to display routes on a map, but I couldn’t complete it due to time constraints.
- **Advanced Filters**: In the future, I might add more search filters, like by time or distance.

## Known Bugs
- **Search Bug**: If you search for both a bus number and one of the locations (either "from" or "to"), the app doesn’t show an error, even if no routes match.


## Tools and Technologies Used
- **BLoC State Management**: I used **BLoC** to manage the app’s logic and state.
- **Flutter**: The app was built using Flutter for the user interface.
- **Hive**: A lightweight database used to store favorite routes locally.
- **API**: The app fetches bus routes from an external API.

## Screenshots
- [Insert screenshots or recording of the app here]

## Operating System Used
- **Windows**

## Design Tools Used
- No external design tools were used. The design was created directly within Flutter.

## References
- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Documentation](https://bloclibrary.dev/flutter-bloc-concepts/)
- [Hive Documentation](https://docs.hivedb.dev)
