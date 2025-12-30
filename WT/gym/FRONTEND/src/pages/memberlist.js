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

  const sty = {
    backgroundImage: "url('https://t3.ftcdn.net/jpg/01/19/59/74/360_F_119597487_SnvLBdheEGOxu05rMQ5tCzo250cRrTz9.jpg')",
    backgroundSize: "cover",
    backgroundPosition: "center",
    height: "auto",
    color: "white",
    display: "flex",
    justifyContent: "center",
  };

  const handleView = (_id) => {
    navigate(`/member/${_id}`);
  };

  const handleEdit = (_id) => {
    navigate(`/editmember/${_id}`);
  };

  function handleDelete(_id) {
    const url = `http://localhost:4000/members/${_id}`;

    fetch(url, {
      method: "DELETE",
      headers: {
        "Content-Type": "application/json",
      },
    })
      .then((res) => {
        window.location.reload();
      })
      .catch((error) => {
        console.error("Error:", error);
      });
  }

  return (
    <div className="container-fluid" style={sty}>
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
                  src={"https://img.freepik.com/premium-photo/indoor-space-gym-ai-technology-generated-image_1112-12533.jpg" || "placeholder-image-url"}
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
    </div>
  );
}

export default MemberList;
