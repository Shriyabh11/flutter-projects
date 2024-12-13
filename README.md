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
- **Advanced Filters**: In the future, I might add more search filters, like by number of stops.
## Known Bugs
- **Search Bug**: If you search for both a bus number and one of the locations (either "from" or "to"), the app doesn’t show an error, even if no routes match.


## Tools and Technologies Used
- **BLoC State Management**: I used **BLoC** to manage the app’s logic and state.
- **Flutter**: The app was built using Flutter for the user interface.
- **Hive**: A lightweight database used to store favorite routes locally.
- **API**: The app fetches bus routes from an external API.

## Screenshots
- ![Screenshot 2024-11-20 165223](https://github.com/user-attachments/assets/312813e0-36f8-4fbf-8744-d3c5a9ea0155)
-![Screenshot 2024-11-20 165255](https://github.com/user-attachments/assets/e0b1d6bf-8513-4a58-b5c2-512a92371bbc)
-![Screenshot 2024-11-20 165332](https://github.com/user-attachments/assets/f9d6cf39-39e5-401e-a2d3-55a6845c0a9c)
-![Screenshot 2024-11-20 165343](https://github.com/user-attachments/assets/f8fc42e8-c091-4f5c-87a2-63761ff4bfcf)

## Video 
-https://drive.google.com/file/d/1mm2FfZFPUdGD1ZoilKvs3HIvjXLC8W0N/view?usp=sharing 






## Design Tools Used
- No external design tools were used. The design was created directly within Flutter.

## References
- [Flutter Documentation](https://flutter.dev/docs)
- [BLoC Documentation](https://bloclibrary.dev/flutter-bloc-concepts/)
- [Hive Documentation](https://docs.hivedb.dev)
