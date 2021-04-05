import './About.scss';

function About() {
  return (
    <>
      <div className="about">
        <h1>Movie Data Scraper</h1>
        <h6>Created for ECE 356 at the University of Waterloo.</h6>
        <p>
          Search for your favourite movie or actor, and maybe learn a bit about them.
          Do you need some new recommendations? Use our tools to find the best picks for you.<br/><br/>

          This app was created using React and TypeScript. Our data was sourced from <a href="https://www.kaggle.com/stefanoleone992/imdb-extensive-dataset">here</a> and <a href="https://www.kaggle.com/rounakbanik/the-movies-dataset">here</a>,
          normalized and stored on a MySQL database.
        </p>
      </div>
      <div className="about-us">
        <h1>Created By</h1>
        <div className="row">
          <div className="col-sm">
            <div className="about-pic" id="walter"/>
            <h2>Walter Alejandro Lam Astudillo</h2>
            <a href="mailto:walamast@uwaterloo.ca">walamast@uwaterloo.ca</a>
          </div>
          <div className="col-sm">
            <div className="about-pic" id="bruce"/>
            <h2>Bruce Nguyen</h2>
            <a href="mailto:b34nguye@uwaterloo.ca">b34nguye@uwaterloo.ca</a>
          </div>
          <div className="col-sm">
            <div className="about-pic" id="darius"/>
            <h2>Darius Andrew Wigglesworth</h2>
            <a href="mailto:dawiggle@uwaterloo.ca">dawiggle@uwaterloo.ca</a>
          </div>
        </div>
      </div>
    </>
  );
}

export default About;
