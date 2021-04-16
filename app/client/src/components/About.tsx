import './About.scss';

function About() {
  return (
    <>
      <div className="about">
        <h1>Movie Data Scraper</h1>
        <h6>Created for ECE 356 at the University of Waterloo.</h6>
        <p>
          Search for your favourite movie or actor, and maybe learn a bit about them.
          Create an account and write reviews for your favourite (and least favourite) movies!.<br/><br/>

          This app was created using React, Express, and TypeScript. Our data was sourced from <a href="https://www.kaggle.com/stefanoleone992/imdb-extensive-dataset">here</a> and <a href="https://www.kaggle.com/rounakbanik/the-movies-dataset">here</a>,
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
            <p>
              Completed the preliminary relational schema design, designed unit tests
              for the schema, and worked on the data-mining analysis.
            </p>
          </div>
          <div className="col-sm">
            <div className="about-pic" id="bruce"/>
            <h2>Bruce Nguyen</h2>
            <a href="mailto:b34nguye@uwaterloo.ca">b34nguye@uwaterloo.ca</a>
            <p>
              Assisted with the relational schema design, and did full-stack development
              for the client application, including unit testing.
            </p>
          </div>
          <div className="col-sm">
            <div className="about-pic" id="darius"/>
            <h2>Darius Andrew Wigglesworth</h2>
            <a href="mailto:dawiggle@uwaterloo.ca">dawiggle@uwaterloo.ca</a>
            <p>
              Responsible for correcting the data for import and implementing the
              schema. Also worked on the data-mining analysis.
            </p>
          </div>
        </div>
      </div>
    </>
  );
}

export default About;
