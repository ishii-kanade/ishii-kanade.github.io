import { useState } from "react";

type CardProps = {
  id: number;
  title: string;
  content: string;
  onUpdate: (id: number, updatedTitle: string, updatedContent: string) => void;
};

const Card: React.FC<CardProps> = ({ id, title, content, onUpdate }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [editTitle, setEditTitle] = useState(title);
  const [editContent, setEditContent] = useState(content);

  const handleSave = () => {
    setIsEditing(false);
    onUpdate(id, editTitle, editContent); // 親コンポーネントに変更を通知
  };

  return (
    <div
      style={{
        border: "1px solid #ccc",
        padding: "10px",
        borderRadius: "8px",
        margin: "10px",
      }}
    >
      {isEditing ? (
        <div>
          <input
            type="text"
            value={editTitle}
            onChange={(e) => setEditTitle(e.target.value)}
            style={{ width: "100%", marginBottom: "5px" }}
          />
          <textarea
            value={editContent}
            onChange={(e) => setEditContent(e.target.value)}
            style={{ width: "100%" }}
          />
          <button onClick={handleSave}>Save</button>
        </div>
      ) : (
        <div onClick={() => setIsEditing(true)}>
          <h3>{title}</h3>
          <p>{content}</p>
        </div>
      )}
    </div>
  );
};

export default Card;
