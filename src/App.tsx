import { useState, useEffect } from "react";
import Card from "./components/Card";

type CardType = {
  id: number;
  title: string;
  content: string;
};

const App: React.FC = () => {
  const [cards, setCards] = useState<CardType[]>(() => {
    const savedCards = localStorage.getItem("cards");
    return savedCards
      ? JSON.parse(savedCards)
      : [
          { id: 1, title: "First Note", content: "This is the first note." },
          { id: 2, title: "Second Note", content: "This is the second note." },
        ];
  });

  const handleUpdateCard = (
    id: number,
    updatedTitle: string,
    updatedContent: string,
  ) => {
    const updatedCards = cards.map((card: CardType) =>
      card.id === id
        ? { ...card, title: updatedTitle, content: updatedContent }
        : card,
    );
    setCards(updatedCards);
    localStorage.setItem("cards", JSON.stringify(updatedCards));
  };

  useEffect(() => {
    localStorage.setItem("cards", JSON.stringify(cards));
  }, [cards]);

  return (
    <>
      <h1>My Notes</h1>
      <div>
        {cards.map((card: CardType) => (
          <Card
            key={card.id}
            id={card.id}
            title={card.title}
            content={card.content}
            onUpdate={handleUpdateCard}
          />
        ))}
      </div>
    </>
  );
};

export default App;
