import React, { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";

function EditMember() {
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
    backgroundColor: "#000", // Set background color to black
    color: "#fff", // Optional: Set text color to white for better contrast
    minHeight: "100vh", // Make sure the background covers the full height
  };
  const { id } = useParams();
  const navigate = useNavigate();
  // console.log(id);

  useEffect(() => {
    // Fetch existing member data based on memberId
    const fetchMemberData = async () => {
      const response = await fetch(`http://localhost:4000/members/${id}`);
      const data = await response.json();
      if (data.DOB) {
        const date = new Date(data.DOB);
        const formattedDOB = date.toISOString().split("T")[0]; // Converts to YYYY-MM-DD
        data.DOB = formattedDOB;
      }
      console.log(data);

      setFormData(data);
    };

    fetchMemberData();
  }, [id]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  function handleSubmit(e) {
    e.preventDefault();
    fetch(`http://localhost:4000/members/${id}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(formData),
    }).then((res) => navigate("/memberlist"));

    // const data = await response.json();
    // console.log(data);

    // navigate("/memberlist");
  }

  return (
    <div className="container-fluid" style={sty}>
      <div className="container">
      <h1 className="text-center mb-5">Gym Membership</h1>
      <div className="card">
        <div className="card-header text-center">
          <h2>Edit Member</h2>
        </div>
        <div className="card-body">
          <form onSubmit={handleSubmit}>
            <div className="form-group m-3">
              <label className="form-label">First Name</label>
              <input
                type="text"
                className="form-control"
                name="Firstname"
                value={formData.Firstname}
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
                value={formData.Lastname}
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
                value={formData.EmailAddress}
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
                value={formData.PhoneNumber}
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
                  checked={formData.Gender === "male"}
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
                  checked={formData.Gender === "female"}
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
                  checked={formData.Gender === "other"}
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
                value={formData.DOB}
                required
                onChange={handleChange}
              />
            </div>

            <div className="form-group m-3">
              <label>Membership Type</label>
              <select
                className="form-select mt-2"
                name="MembershipType"
                value={formData.MembershipType}
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
                className="btn btn-warning mt-3 col-2 mx-auto"
                value="Edit"
              />
            </div>
          </form>
        </div>
      </div>
    </div>
    </div>
  );
}

export default EditMember;
