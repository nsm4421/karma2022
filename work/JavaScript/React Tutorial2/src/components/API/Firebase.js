import { initializeApp } from 'firebase/app';
import { getDatabase, ref, onValue, set} from "firebase/database";

// TODO: Replace with your app's Firebase project configuration
const firebaseConfig = {
  apiKey: "AIzaSyB2HGMmxaEPI5VMf2gTA6Yi01AXgL7NtT8",
  authDomain: "react-tutorial-a34d0.firebaseapp.com",
  databaseURL: "https://react-tutorial-a34d0-default-rtdb.firebaseio.com",
  projectId: "react-tutorial-a34d0",
  storageBucket: "react-tutorial-a34d0.appspot.com",
  messagingSenderId: "543382533152",
  appId: "1:543382533152:web:9be5390be5313160357845",
  measurementId: "G-PTWLHLKN2J"
};


const app = initializeApp(firebaseConfig)

const myDB = getDatabase(app)

export default myDB;

