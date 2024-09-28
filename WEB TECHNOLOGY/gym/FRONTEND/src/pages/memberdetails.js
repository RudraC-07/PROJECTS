import React, { useEffect, useState } from "react";
import { useParams,Link } from "react-router-dom";

function MemberDetails() {
  const [member, setMember] = useState({});
  const { id } = useParams();
  const sty = {
    width : "310px",
    height : "200px"
  }

  useEffect(() => {
    fetch("http://localhost:4000/members/" + id)
      .then((res) => res.json())
      .then((res) => setMember(res));
  }, []);

  console.log(member);
  return (
    <div className="container">
      <div class="card mb-3">
        <div class="row g-0">
          <div class="col-md-4">
            <img src="https://img.freepik.com/premium-photo/indoor-space-gym-ai-technology-generated-image_1112-12533.jpg" class="img-fluid rounded float-start mx-4 my-5" style={sty} alt="..." />
            
          </div>
          <div class="col-md-8">
            <div class="card-body">
              <div class="card-header text-center"><h2>Details of Member</h2></div>
              <div class="row mb-3 mt-3"><h5 class="card-title col">First Name</h5> <h5 class="card-text col">:</h5> <p class="card-text col-4">{member.Firstname}</p></div>
              <div class="row mb-3"><h5 class="card-title col">Last Name</h5> <h5 class="card-text col">:</h5> <p class="card-text col-4">{member.Lastname}</p></div>
              <div class="row mb-3"><h5 class="card-title col">Email</h5> <h5 class="card-text col">:</h5> <p class="card-text col-4">{member.EmailAddress}</p></div>
              <div class="row mb-3"><h5 class="card-title col">Contact</h5> <h5 class="card-text col">:</h5> <p class="card-text col-4">{member.PhoneNumber}</p></div>
              <div class="row mb-3"><h5 class="card-title col">Gender</h5> <h5 class="card-text col">:</h5> <p class="card-text col-4">{member.Gender}</p></div>
              <div class="row mb-3"><h5 class="card-title col">Date of Birth</h5> <h5 class="card-text col">:</h5> <p class="card-text col-4">{member.DOB}</p></div>
              <div class="row mb-3"><h5 class="card-title col">Membership Type</h5> <h5 class="card-text col">:</h5> <p class="card-text col-4">{member.MembershipType}</p></div>
              <div className="row"><Link to="/memberlist" className="btn btn-info mt-3 col-2 mx-auto"><i class="bi bi-arrow-left"></i> Back</Link></div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

export default MemberDetails;
