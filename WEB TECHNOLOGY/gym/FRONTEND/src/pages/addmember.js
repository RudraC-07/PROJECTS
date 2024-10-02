import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

function AddMember() {
  // const navigate = useNavigate()
  const [formData, setFormData] = useState({
    Firstname: "",
    Lastname: "",
    EmailAddress: "",
    PhoneNumber: "",
    Gender: "",
    DOB: "",
    MembershipType: "",
  });

  const sty = {
    backgroundImage: "url('https://t3.ftcdn.net/jpg/01/19/59/74/360_F_119597487_SnvLBdheEGOxu05rMQ5tCzo250cRrTz9.jpg')",
    backgroundSize: "cover",
    backgroundPosition: "center",
    height: "auto",
    color: "white",
    display: "flex",
    justifyContent: "center",
  };

  const navigate = useNavigate();

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  function handleSubmit(e){
    e.preventDefault();
    fetch("http://localhost:4000/members", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(formData),
    }).then(res => navigate("/memberlist"))
  };

  return (
    <div className="container-fluid" style={sty}>
      <div className="container">
      <h1 className="text-center mb-5">Gym Membership</h1>
      <div className="card">
        <div className="card-header text-center">
          <h2>Add New Member</h2>
        </div>
        <div className="card-body">
          <form onSubmit={handleSubmit}>
            <div className="form-group m-3">
              <label className="form-label">First Name</label>
              <input
                type="text"
                className="form-control"
                name="Firstname"
                onChange={handleChange}
                required
              />
            </div>
            <div className="form-group m-3">
              <label className="form-label">Last Name</label>
              <input
                type="text"
                className="form-control"
                name="Lastname"
                onChange={handleChange}
                required
              />
            </div>
            <div className="form-group m-3">
              <label htmlFor="email">Email Address</label>
              <input
                type="email"
                className="form-control mt-2"
                name="EmailAddress"
                required
                onChange={handleChange}
              />
            </div>
            <div className="form-group m-3">
              <label htmlFor="phone">Phone Number</label>
              <input
                type="tel"
                className="form-control mt-2"
                name="PhoneNumber"
                required
                onChange={handleChange}
              />
            </div>
            <div className="form-group m-3">
              <div className="mb-2">
                <label>Gender</label>
              </div>
              <div className="mx-3 form-check form-text">
                <input
                  className="form-check-input"
                  type="radio"
                  name="Gender"
                  id="genderMale"
                  value="male"
                  onChange={handleChange}
                />
                <label className="form-check-label" htmlFor="genderMale">
                  Male
                </label>
              </div>
              <div className="mx-3 form-check form-text">
                <input
                  className="form-check-input"
                  type="radio"
                  name="Gender"
                  id="genderFemale"
                  value="female"
                  onChange={handleChange}
                />
                <label className="form-check-label" htmlFor="genderFemale">
                  Female
                </label>
              </div>
              <div className="mx-3 form-check form-text">
                <input
                  className="form-check-input"
                  type="radio"
                  name="Gender"
                  id="genderOther"
                  value="other"
                  onChange={handleChange}
                />
                <label className="form-check-label" htmlFor="genderOther">
                  Other
                </label>
              </div>
            </div>

            <div className="form-group m-3">
              <label htmlFor="dob">Date of Birth</label>
              <input
                type="date"
                className="form-control mt-2"
                name="DOB"
                required
                onChange={handleChange}
              />
            </div>

            <div className="form-group m-3">
              <label>Membership Type</label>
              <select
                className="form-select mt-2"
                name="MembershipType"
                onChange={handleChange}
                required
              >
                <option value="">Select Membership</option>
                <option value="Basic">Basic</option>
                <option value="Premium">Premium</option>
                <option value="VIP">VIP</option>
              </select>
            </div>
            <div className="row form-group m-3">
              <input
                type="submit"
                className="btn btn-primary mt-3 col-2 mx-auto"
                value="Add"
              />
            </div>
          </form>
        </div>
      </div>
    </div>

    </div>
    
  );
}

export default AddMember;
