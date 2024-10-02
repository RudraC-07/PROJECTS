function Home() {
  const sty = {
    backgroundImage: "url('https://t3.ftcdn.net/jpg/01/19/59/74/360_F_119597487_SnvLBdheEGOxu05rMQ5tCzo250cRrTz9.jpg')",
    backgroundSize: "cover",
    backgroundPosition: "center",
    height: "100vh",
    color: "white",
    display: "flex",
    justifyContent: "flex-start",
    textAlign: "left",
    padding: "20px"
  };

  return (
    <>
      <div className="container-fluid" style={sty}>
        <div className="row w-100">
          <h1 className="col d-flex justify-content align-items-center display-3 mb-5 mx-5"><b>XYZ GYM</b></h1>
          <div className="col-12 d-flex justify-content-start align-items-start mx-5">
            <div className="col mx-3"> 
              <span className="fs-3"><i><b>Address</b></i></span> <br/> 
              ABC Complex, Rajkot
            </div>
          </div>
          <div className="col-12 d-flex justify-content-start align-items-start mx-5">
            <div className="col mx-5"> 
              <span className="fs-3"><i><b>Membership</b></i></span> <br/> 
              Basic: ₹3000 <br/> Duration: 3 months;<br/> 
              Premium: ₹7000 <br/> Duration: 6 months;<br/> 
              VIP: ₹15000 <br/> Duration: 1 year<br/>
            </div>
          </div>
          <div className="col-12 d-flex justify-content-start align-items-start mx-5">
            <div className="col mx-3"> 
              <span className="fs-3"><i><b>Contact Us</b></i></span> <br/> 
              ABC: 1122334455<br/>
              XYZ: 3344556677
            </div>
          </div>
        </div>
      </div>
    </>
  );
}

export default Home;
