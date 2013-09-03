-----------------------------------------------------------------------
--             DO NOT EDIT THIS FILE. IT IS AUTOGENERATED            --
-- Edit the original file in the macroed_functions directory instead --
-----------------------------------------------------------------------
-- Generated by Ora2Pg, the Oracle database Schema converter, version 11.4
-- Copyright 2000-2013 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=mydb.mydom.fr;sid=SIDNAME


CREATE OR REPLACE FUNCTION tm_cz.rwg_remove_study (
  trialID text,
  currentJobID bigint DEFAULT null
)
 RETURNS BIGINT AS $body$
DECLARE
--Audit variables
	newJobFlag    smallint;
    databaseName  varchar(100);
    procedureName varchar(100);
    jobID         bigint;
    stepCt        bigint;
    rowCt         bigint;
    errorNumber   varchar;
    errorMessage  varchar;

	sqlText      varchar(500);
	partExists   boolean;
	V_BIO_EXP_ID bigint;
	partTable    text;

BEGIN
	--Set Audit Parameters
    newJobFlag := 0; -- False (Default)
    jobID := currentJobID;
    SELECT current_user INTO databaseName; --(sic)
    procedureName := 'RWG_REMOVE_STUDY';

    --Audit JOB Initialization
    --If Job ID does not exist, then this is a single procedure run and we need to create it
    IF (coalesce(jobID::text, '') = '' OR jobID < 1)
        THEN
        newJobFlag := 1; -- True
        SELECT cz_start_audit(procedureName, databaseName) INTO jobID;
    END IF;
    PERFORM cz_write_audit(jobId, databaseName, procedureName,
        'Start FUNCTION', 0, stepCt, 'Done');
    stepCt := 1;

	partTable := 'heat_map_results_' || lower(trialID);

	BEGIN
	SELECT bio_experiment_id INTO V_BIO_EXP_ID
	FROM biomart.bio_experiment
	WHERE UPPER ( accession ) LIKE UPPER ( trialID );
	GET DIAGNOSTICS rowCt := ROW_COUNT;
	PERFORM cz_write_audit(jobId, databaseName, procedureName,
        'Retrieved exp id ' || V_BIO_EXP_ID || ' for trial ' || upper(trialID), rowCt, stepCt, 'Done');
    stepCt := stepCt + 1;
    EXCEPTION
        WHEN OTHERS THEN
        errorNumber := SQLSTATE;
        errorMessage := SQLERRM;
        PERFORM cz_error_handler(jobID, procedureName, errorNumber, errorMessage);
        PERFORM cz_end_audit (jobID, 'FAIL');
        RETURN -16;
    END;

	--check that the experiment id exists
	IF NOT FOUND THEN
		RAISE 'Experiment is missing';
	END IF;

	/************* Delete existing records for study ******************/
	BEGIN
	DELETE
	FROM
		biomart.bio_analysis_attribute_lineage baal
	WHERE
		baal.bio_analysis_attribute_id IN (
			SELECT
				baa.bio_analysis_attribute_id
			FROM
				biomart.bio_analysis_attribute baa
			WHERE
				UPPER ( baa.study_id ) = UPPER ( trialID ) );
	GET DIAGNOSTICS rowCt := ROW_COUNT;
	PERFORM cz_write_audit(jobId, databaseName, procedureName,
        'Delete existing records from Biomart.bio_analysis_attribute_lineage', rowCt, stepCt, 'Done');
    stepCt := stepCt + 1;
    EXCEPTION
        WHEN OTHERS THEN
        errorNumber := SQLSTATE;
        errorMessage := SQLERRM;
        PERFORM cz_error_handler(jobID, procedureName, errorNumber, errorMessage);
        PERFORM cz_end_audit (jobID, 'FAIL');
        RETURN -16;
    END;

	BEGIN
	DELETE
	FROM
		biomart.bio_analysis_attribute baa
	WHERE
		UPPER ( baa.study_id ) = UPPER ( trialID );
	GET DIAGNOSTICS rowCt := ROW_COUNT;
	PERFORM cz_write_audit(jobId, databaseName, procedureName,
        'Delete existing records from Biomart.bio_analysis_attribute', rowCt, stepCt, 'Done');
    stepCt := stepCt + 1;
    EXCEPTION
        WHEN OTHERS THEN
        errorNumber := SQLSTATE;
        errorMessage := SQLERRM;
        PERFORM cz_error_handler(jobID, procedureName, errorNumber, errorMessage);
        PERFORM cz_end_audit (jobID, 'FAIL');
        RETURN -16;
    END;

	BEGIN
	DELETE
	FROM
		biomart.bio_analysis_cohort_xref bacx
	WHERE
		UPPER ( bacx.study_id ) = UPPER ( trialID );
	GET DIAGNOSTICS rowCt := ROW_COUNT;
	PERFORM cz_write_audit(jobId, databaseName, procedureName,
        'Delete existing records from Biomart.bio_analysis_cohort_xref', rowCt, stepCt, 'Done');
    stepCt := stepCt + 1;
    EXCEPTION
        WHEN OTHERS THEN
        errorNumber := SQLSTATE;
        errorMessage := SQLERRM;
        PERFORM cz_error_handler(jobID, procedureName, errorNumber, errorMessage);
        PERFORM cz_end_audit (jobID, 'FAIL');
        RETURN -16;
    END;

	BEGIN
	DELETE
	FROM
		biomart.bio_cohort_exp_xref bcex
	WHERE
		UPPER ( bcex.study_id ) = UPPER ( trialID );
	GET DIAGNOSTICS rowCt := ROW_COUNT;
	PERFORM cz_write_audit(jobId, databaseName, procedureName,
        'Delete existing records from Biomart.bio_cohort_exp_xref', rowCt, stepCt, 'Done');
    stepCt := stepCt + 1;
    EXCEPTION
        WHEN OTHERS THEN
        errorNumber := SQLSTATE;
        errorMessage := SQLERRM;
        PERFORM cz_error_handler(jobID, procedureName, errorNumber, errorMessage);
        PERFORM cz_end_audit (jobID, 'FAIL');
        RETURN -16;
    END;

	BEGIN
	DELETE
	FROM
		biomart.bio_assay_cohort bac
	WHERE
		UPPER ( bac.study_id ) = UPPER ( trialID );
	GET DIAGNOSTICS rowCt := ROW_COUNT;
	PERFORM cz_write_audit(jobId, databaseName, procedureName,
        'Delete existing records from Biomart.bio_assay_cohort', rowCt, stepCt, 'Done');
    stepCt := stepCt + 1;
    EXCEPTION
        WHEN OTHERS THEN
        errorNumber := SQLSTATE;
        errorMessage := SQLERRM;
        PERFORM cz_error_handler(jobID, procedureName, errorNumber, errorMessage);
        PERFORM cz_end_audit (jobID, 'FAIL');
        RETURN -16;
    END;

	BEGIN
	DELETE
	FROM
		biomart.bio_assay_analysis_data baad
	WHERE
		baad.bio_experiment_id = V_BIO_EXP_ID;
	GET DIAGNOSTICS rowCt := ROW_COUNT;
	PERFORM cz_write_audit(jobId, databaseName, procedureName,
        'Delete existing records from Biomart.bio_assay_analysis_data', rowCt, stepCt, 'Done');
    stepCt := stepCt + 1;
    EXCEPTION
        WHEN OTHERS THEN
        errorNumber := SQLSTATE;
        errorMessage := SQLERRM;
        PERFORM cz_error_handler(jobID, procedureName, errorNumber, errorMessage);
        PERFORM cz_end_audit (jobID, 'FAIL');
        RETURN -16;
    END;

	BEGIN
	DELETE
	FROM
		biomart.bio_assay_analysis baa
	WHERE
		baa.bio_assay_analysis_id IN (
			SELECT
				DISTINCT hmr.bio_assay_analysis_id
			FROM
				biomart.heat_map_results hmr
			WHERE
				hmr.trial_name = UPPER ( trialID ) );
	GET DIAGNOSTICS rowCt := ROW_COUNT;
	PERFORM cz_write_audit(jobId, databaseName, procedureName,
        'Delete existing records from Biomart.bio_assay_analysis', rowCt, stepCt, 'Done');
    stepCt := stepCt + 1;
    EXCEPTION
        WHEN OTHERS THEN
        errorNumber := SQLSTATE;
        errorMessage := SQLERRM;
        PERFORM cz_error_handler(jobID, procedureName, errorNumber, errorMessage);
        PERFORM cz_end_audit (jobID, 'FAIL');
        RETURN -16;
    END;

	/***********************************/
	/**** Remove Heat_map_resultes ***/
	/***********************************/
	/* Check if partition exist, truncate if so, create it if not */
	SELECT
		EXISTS (
			SELECT *
			FROM pg_tables
			WHERE
				schemaname = 'biomart'
				AND tablename = partTable )
    INTO partExists;

	IF partExists THEN
		sqlText := 'DROP TABLE biomart.' || partTable || ' CASCADE';
		BEGIN
		EXECUTE(sqlText);
		PERFORM cz_write_audit(jobId, databaseName, procedureName,
        'Drop partition table of heat_map_results', 0, stepCt, 'Done');
    stepCt := stepCt + 1;
    EXCEPTION
        WHEN OTHERS THEN
        errorNumber := SQLSTATE;
        errorMessage := SQLERRM;
        PERFORM cz_error_handler(jobID, procedureName, errorNumber, errorMessage);
        PERFORM cz_end_audit (jobID, 'FAIL');
        RETURN -16;
    END;
	END IF;

	PERFORM cz_write_audit(jobId,databaseName,procedureName,'FUNCTION Complete',0,stepCt,'Done');
	RETURN 0;

	---Cleanup OVERALL JOB if this proc is being run standalone
	IF newJobFlag = 1
		THEN
		PERFORM cz_end_audit (jobID, 'SUCCESS');
	END IF;
EXCEPTION
	WHEN OTHERS THEN
	errorNumber := SQLSTATE;
        errorMessage := SQLERRM;
        PERFORM cz_error_handler(jobID, procedureName, errorNumber, errorMessage);
        PERFORM cz_end_audit (jobID, 'FAIL');
        RETURN -16;
END;
$body$
LANGUAGE PLPGSQL;
