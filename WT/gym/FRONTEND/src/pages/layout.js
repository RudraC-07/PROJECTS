import {Link,Outlet} from 'react-router-dom';

function Layout(){
  return(
    <>
      <nav class="navbar navbar-expand-lg bg-body-tertiary" style={{"height":"55px"}}>
        <div class="container-fluid">

          <Link class="navbar-brand" to="/">
            <img src="./images/gym2.png" alt="Logo" width="30" height="30" class="d-inline-block align-text-top mx-2" />
            XYZ Gym
          </Link>
          <div class="d-flex justify-content-end pt-4" id="navbarNav">
            <ul class="navbar-nav">
              <li class="nav-item">
                <Link to="/" className='nav-link'>Home</Link> &nbsp;
              </li>
              <li class="nav-item">
                <Link to="/about" className='nav-link pt-2'>About</Link> &nbsp;
              </li>
              <li class="nav-item">
                <Link to="/memberlist" className='nav-link pt-2'>Members List</Link> &nbsp;
              </li>
              <li class="nav-item">
                <Link to="/addmember" className='nav-link pt-2'>Add member</Link> &nbsp;
              </li>
            </ul>
          </div>
        </div>
      </nav>  

        <div className='row'>
          <div className='col mt-2'><Outlet/></div>
        </div>
    </>
  );
}

export default Layout;