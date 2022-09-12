import styles from "../styles/Home.module.css";

function About({ numTokenMinted }) {
  return (
    <>
      <div className={styles.main}>
        <h1 style={{ color: "white" }}>Welcome to Next.js! {numTokenMinted}</h1>
      </div>
      <footer className={styles.footer}>Made with 💓 by CryptoMon</footer>
    </>
  );
}

export default About;
