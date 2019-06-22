package com.dub.spring.depthFirstSearch;


/** container for AJAX response */
public class StepResult {
	
	private JSONSnapshot snapshot;
	private Status status;
	


	public JSONSnapshot getSnapshot() {
		return snapshot;
	}

	public void setSnapshot(JSONSnapshot snapshot) {
		this.snapshot = snapshot;
	}

	public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}
	

	public enum Status {
		STEP, FINISHED
	}
}
