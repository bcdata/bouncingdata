<div id="help-content">
  <h3>R APIs Reference</h3>
  <div class="help-main-content">
    <div>
      <h3>Datastore</h3>
      <p>
        BouncingData provides a full, scalable SQL-supported datastore which users can store, load and query data from their analysis.
      </p>
      <p>
        This section describes the R APIs to work with BouncingData datastore. 
      </p>
      <p>Import Datastore module in R</p>
      <div class="code-outer">
        <code>library(datastore)</code>
      </div>
     
      <dl>
        <dt>datastore::<strong>load</strong>(dataset)</dt>
        <dd>
          <p>Load data from given dataset.</p>
          <p><var>dataset</var> dataset name. </p>
          <p>Returns dataframe object</p>
        </dd>
        <dt>datastore::<strong>query</strong>(query)</dt>
        <dd>
          <p>
            Run a SQL query against Bouncingdata datastore.
          </p>
          <p>Returns dataframe object</p>
          <p>
            <var>query</var> the SQL query string.
          </p>
        </dd>
        <dt>datastore::<strong>attach</strong>(attachment_name, dataframe)</dt>
        <dd>
          <p>
            Attach data as an attachment of current analysis. The attachments will appear in 'Data' tab of current analysis.
          </p>
          <p>
            <var>attachment_name</var> Name of attachment.
          </p>
          <p>
            <var>dataframe</var> R Dataframe to attach.
          </p>
        </dd>
      </dl>      
    </div>
    
    <div>
     <h3>BCPublish</h3>
      <p>
        BouncingData provides a package to be installed on client side, which supports users to publish their local analysis and dataset easily to bouncingdata.com.
      </p>
      <p>
        This section describes the R APIs to work with BouncingData BCPublish. Download this package along with manual <a href="https://github.com/bcdata/bouncingdata/tree/minimal/Client_Packages/R" class="help-page-link">here </a>
      </p>
      <p>Import BCPublish module in R</p>
      <div class="code-outer">
        <code>library(BCPublish)</code>
      </div>
     
      <dl>
        <dt>BCPublish::<strong>bcAnalysisPublish</strong>(filename, title, description, public)</dt>
        <dd>
          <p>Publish an analysis by uploading a R file and having it executed on the server automatically to generate visualization.</p>
          <p><var>filename</var> Name of the analysis R file (required). </p>
          <p><var>title</var> Title of the new analysis (optional). Default "Analysis Title". </p>
          <p><var>description</var> Description of the new analysis (optional). Default "Analysis description". </p>
          <p><var>public</var> Make the new analysis public or not on bouncingdata.com (optional). Default "False". </p>
          <p>Returns URL of the new analysis, in the successful case. Otherwise, an error message would be displayed. </p>
        </dd>
        
        <dt>BCPublish::<strong>bcDatasetPublish</strong>(filename, title, description, tags, public)</dt>
        <dd>
          <p>
            Publish a dataset by uploading a csv, txt or xls file.
          </p>
          <p><var>filename</var> The data file name (required). </p>
          <p><var>title</var> Title of the new dataset (optional). Default "Dataset Title". </p>
          <p><var>description</var> Description of the new dataset (optional). Default "Dataset description". </p>
          <p><var>tags</var> Tags to be attached to the new dataset (optional). Default "" (i.e. no tag). </p>
          <p><var>public</var> Make the new dataset public or not on bouncingdata.com (optional). Default "False". </p>
          <p>Returns URL of the new dataset, in the successful case. Otherwise, an error message would be displayed. </p>
        </dd>
      </dl>      
    </div>

  </div>
</div>