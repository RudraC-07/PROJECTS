//

function Home() {
  const sty = {
    backgroundImage: "url('https://wallpaperaccess.com/full/2968326.jpg')", // Background image URL
    backgroundSize: "cover", // Cover the entire area
    backgroundPosition: "center", // Center the image
    height: "100vh", // Full viewport height
    color: "white", // Text color for visibility
    display: "flex", // Flexbox layout
    // alignItems: "center", // Vertically center
    justifyContent: "center", // Horizontally center
    textAlign: "center", // Center text
  };

  return (
    <>
      <div className="container-fluid" style={sty}>
        <div className="row w-100">
          <h1 className="col-12 d-flex justify-content-center align-items-center display-3">XYZ GYM</h1>
          <div className="col-12 d-flex justify-content-between align-items-end">
            <div className="col"> <span className="fs-1">Address</span>  <br/> Rudra</div>
            <div className="col"> <span className="fs-1">Membership</span> </div>
            <div className="col"> <span className="fs-1">Contact</span> </div>
          </div>
        </div>
      </div>
      {/* <div class="row d-flex justify-content-between" style={sty}>
        
      </div> */}
    </>
  );
}

export default Home;
