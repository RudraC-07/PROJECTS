import { BrowserRouter, Route, Routes } from 'react-router-dom';
import About from './pages/about.js';
import AddMember from './pages/addmember.js';
import Home from './pages/home.js';
import Layout from './pages/layout.js';
import MemberList from './pages/memberlist.js';
import MemberDetails from './pages/memberdetails.js';
import EditMember from './pages/editmember.js';


function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element = {<Layout />}>
          <Route index element = {<Home />}></Route>
          <Route path="/about" element = {<About />}></Route>
          <Route path="/memberlist" element = {<MemberList />}></Route>
          <Route path="/addmember" element = {<AddMember />}></Route>
          <Route path="/member/:id" element = {<MemberDetails />}></Route>
          <Route path="/editmember/:id" element = {<EditMember />}></Route>
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
