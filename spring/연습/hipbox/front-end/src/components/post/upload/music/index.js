import { useState } from "react";
import { Button } from "react-bootstrap";
import Form from 'react-bootstrap/Form';
import { useNavigate } from "react-router-dom";
import Api from "../../../../utils/Api";
import textUtil from "../../../../utils/textUtil";
import { RiFolderMusicFill } from "@react-icons/all-files/ri/RiFolderMusicFill";
import { AiFillPicture } from "@react-icons/all-files/ai/AiFillPicture";
import { FaHashtag } from "@react-icons/all-files/fa/FaHashtag";
import { AiFillPlusCircle } from "@react-icons/all-files/ai/AiFillPlusCircle";
import { AiFillMinusCircle } from "@react-icons/all-files/ai/AiFillMinusCircle";
import { BiBracket } from "@react-icons/all-files/bi/BiBracket";
import { AiOutlineCloudUpload } from "@react-icons/all-files/ai/AiOutlineCloudUpload";

const UploadForm = () => {

  const navigator = useNavigate();
  const [title, setTitle] = useState("");
  const [description, setDescription] = useState("");
  const [hashtag, setHashtag] = useState([]);
  const [isLoading, setIsLoading] = useState(false);

  const handleTitle = textUtil(30, setTitle);
  const handleDescription = textUtil(3000, setDescription);

  const handleHashtag = (idx) => (e) => {
    const newHashtag = [... hashtag];
    let v = e.target.value;
    if (v.length <= 30){
      v = v.slice(0, Math.min(v.length, 30));
    }
    newHashtag[idx] = e.target.value;
    setHashtag(newHashtag);
  }

  const addHashtag = (e) => {
    e.preventDefault();
    if (hashtag.length<5){
      setHashtag([...hashtag, ""]);
    };
  }

  const deleteHashtag = (idx) => (e) => {
    e.preventDefault();
    let newHashtag = [... hashtag];
    newHashtag.pop(idx);
    setHashtag(newHashtag);
  }

  const handleSubmit = (e)=>{
    setIsLoading(true);
    e.preventDefault();
    let music = document.getElementById("music").files[0];
    let thumbnail = document.getElementById("thumbnail").files[0];
     
    const formData = new FormData();

    formData.append("title", title);
    formData.append("description", description);
    formData.append("hashtag", new Set(hashtag));
    formData.append("music", music);  
    formData.append("thumbnail", thumbnail);
  
    let xhr = new XMLHttpRequest();
    xhr.open(Api.uploadMusic.METHOD, Api.uploadMusic.URL); 
    xhr.setRequestHeader("Authorization", `Bearer ${localStorage.getItem('token')}`);
    xhr.onload = (e) => { 
      const res = JSON.parse(e.target.response)
      if(res.resultCode === "SUCCESS"){
        alert("????????? ????????? ???????????????.");
        navigator("/");
      } else {
        alert("?????? ???????????? ?????????????????????.");
        console.log(e);
      }
    }; 
    xhr.send(formData);
    setIsLoading(false); 
  };

  return (
  
    <Form>

        <Form.Group className="mt-3">
          <BiBracket style={{marginRight:'10px'}}/>
          <Form.Label>??????</Form.Label>
          <Form.Control className="mt-3" onChange={handleTitle} value={title} placeholder="30??? ????????? ??????????????????"/>
        </Form.Group>
        
        <Form.Group className="mt-3">
          <BiBracket style={{marginRight:'10px'}}/>
          <Form.Label className="mt-3">??????</Form.Label>
          <Form.Control as={"textArea"} style={{resize:"none"}} className="mt-3" onChange={handleDescription} 
            value={description} placeholder="3000??? ????????? ??????????????????"/>
        </Form.Group>
        
        <Form.Group className="mt-3">
          <Form.Label className="mt-3"><AiFillPicture style={{marginRight:'10px'}}/>?????????</Form.Label>
          <Form.Control type="file" className="mt-3" id="thumbnail"/>
          <Form.Text>.jpg / .png</Form.Text>
        </Form.Group>
        
        <Form.Group className="mt-3">
          <Form.Label className="mt-3"><RiFolderMusicFill style={{marginRight:'10px'}}/>??????</Form.Label>
          <Form.Control type="file" className="mt-3" id="music"/>
          <Form.Text>.mp4 / .avi</Form.Text>
        </Form.Group>

        <Form.Group className="mt-3">
          <Form.Label className="mt-3"><FaHashtag style={{marginRight:'10px'}}/>????????????</Form.Label>
          <br/>
          <div onClick={addHashtag} className="mt-1">
            <AiFillPlusCircle style={{marginRight:'10px'}}></AiFillPlusCircle>
            <Form.Text className="mt-3">?????? 5????????? ??????????????? ????????? ??? ????????????.</Form.Text>
          </div>

            {
              [...Array(hashtag.length).keys()].map((_, idx)=>{
                return (
                  <span key={idx} className="mt-3" style={{display:"flex", alignItems:"center"}}>
                    <input onChange={handleHashtag(idx)} value={hashtag[idx]} placeholder={`hashtag ${idx+1}`}
                      style={{borderTop:"none", borderLeft:"none", borderRight:"none"}}></input>
                    <AiFillMinusCircle onClick={deleteHashtag(idx)} style={{marginLeft:'10px'}}/>
                  </span>
                )
                })
            }

        </Form.Group>
    
        <Button type="submit" variant="success" className="mt-3" disabled={isLoading} onClick={handleSubmit}>
          <AiOutlineCloudUpload/> ?????????
        </Button>
    
    </Form>
  )
};

export default UploadForm;