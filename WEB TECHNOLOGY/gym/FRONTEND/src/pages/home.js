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
    textAlign: "center" // Center text
  };

  return (
    <>
      <div className="container-fluid" style={sty}>
        <div><h1>XYZ GYM</h1></div>
        
      </div>
      <div class="row d-flex justify-content-between" style={sty}>
        <div className="col">Address</div>
        <div className="col">Membership</div>
        <div className="col">Contact</div>
      </div>
    </>
  );
}

export default Home;