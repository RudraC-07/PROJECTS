import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";

function MemberList() {
  const [members, setMembers] = useState([]);
  const length = members.length;
  const navigate = useNavigate();

  useEffect(() => {
    fetch("http://localhost:4000/members")
      .then((res) => res.json())
      .then((res) => setMembers(res))
      .catch((error) => console.error("Error fetching members:", error));
  }, []);

  const handleView = (_id) => {
    navigate(`/member/${_id}`); // Change to the appropriate route
  };

  const handleEdit = (_id) => {
    navigate(`/editmember/${_id}`); // Change to the appropriate route
  };

  function handleDelete(_id) {
    const url = `http://localhost:4000/members/${_id}`;

    fetch(url, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
        // Include any necessary authorization headers here
      },
    })
      .then((res) => {
        // Check if the response is okay
        window.location.reload();
        // return res.json(); // or handle response if needed
      })
      // .then((data) => {
      //   console.log(`Successfully deleted member with ID: ${_id}`);
      //   window.location.reload(); // Refresh the page
      // })
      .catch((error) => {
        console.error("Error:", error);
      });
  }

  return (
    <div className="container">
      <div className="row mx-3">
        {length === 0 ? (
          <div style={{height:"80vh"}} className="d-flex align-items-center justify-content-center">
            <p className="text-center display-3 ">No Members Currently</p>
          </div>
        ) : (
          members?.map((m) => (
            <div className="col-md-4 mb-4" key={m._id}>
              <div className="card m-3 p-2" style={{ width: "18rem" }}>
                <img
                  src={"https://img.freepik.com/premium-photo/indoor-space-gym-ai-technology-generated-image_1112-12533.jpg" || "placeholder-image-url"} // Replace with your placeholder image URL
                  className="card-img-top rounded float-start"
                  alt={`${m.Firstname} ${m.Lastname}`}
                />
                <div className="card-body">
                  <h5 className="card-title">
                    {m.Firstname} {m.Lastname}
                  </h5>
                  <p className="card-text">
                    <strong>Email:</strong> {m.EmailAddress}
                    <br />
                  </p>
                  <div className="row mx-3">
                    <button
                      onClick={() => handleView(m._id)}
                      className="btn btn-primary col-3 m-2"
                    >
                      <i className="bi bi-eye"></i>
                    </button>

                    <button
                      onClick={() => handleEdit(m._id)}
                      className="btn btn-warning col-3 m-2"
                    >
                      <i className="bi bi-pencil-fill"></i>
                    </button>

                    <button
                      onClick={() => handleDelete(m._id)}
                      className="btn btn-danger col-3 m-2"
                    >
                      <i className="bi bi-trash"></i>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
}

export default MemberList;
