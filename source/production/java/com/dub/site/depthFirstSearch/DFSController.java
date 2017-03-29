package com.dub.site.depthFirstSearch;

import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.dub.config.annotation.WebController;

@WebController
public class DFSController {
	
	@Inject
	private GraphServices graphServices;
	
	/** Initialize graph from JSON object sent by browser
	 * This method is called only one time 
	 */
	@RequestMapping(value="initGraph")
	@ResponseBody
	public DFSResponse initGraph(@RequestBody GraphInitRequest message, 
				HttpServletRequest request) 
	{	
		System.out.println("controller: initGraph begin");
		
		HttpSession session = request.getSession();
	
		if (session.getAttribute("graph") != null) {
			session.removeAttribute("graph");
		}
		
		List<JSONEdge> jsonEdges = message.getJsonEdges();
		List<JSONVertex> jsonVertices = message.getJsonVertices();
	
		DFSGraph graph = new DFSGraph(jsonVertices.size());
			
		for (int i1 = 0; i1 < jsonVertices.size(); i1++) {
			DFSVertex v = new DFSVertex();
			v.setName(jsonVertices.get(i1).getName());
			v.setColor(DFSVertex.Color.BLACK);
			graph.getVertices()[i1] = v;
		}
		
		for (int i1 = 0; i1 < jsonEdges.size(); i1++) {
			JSONEdge edge = jsonEdges.get(i1);
			int from = edge.getFrom();
			int to = edge.getTo();
			DFSVertex v1 = (DFSVertex)graph.getVertices()[from];
			v1.getAdjacency().add(to);
		}
		
		/** Save the new graph to the session context */
		session.setAttribute("graph", graph);
			
		DFSResponse dfsResponse = new DFSResponse();
		dfsResponse.setStatus(DFSResponse.Status.OK);
	
		System.out.println("controller: graph built");
		
		// here the graph is ready for the search loop
		
		System.out.println("controller: initGraph completed");
			
		return dfsResponse;
	}
	
	
	@RequestMapping(value="searchStep")
	@ResponseBody
	public StepResult searchStep(@RequestBody SearchRequest message, 
				HttpServletRequest request) 
	{
		/** 
		 * This method is called by an Ajax request on each search step
		 * it returns a JSON object that contains both colored vertices 
		 * and edges
		 */
		
		HttpSession session = request.getSession();
		DFSGraph graph = (DFSGraph)session.getAttribute("graph");
				
		graph.searchStep();// actual step
		JSONSnapshot snapshot = graphServices.graphToJSON(graph);
		
		StepResult result = new StepResult();
		
		result.setSnapshot(snapshot);
		if (graph.isFinished()) {
			result.setStatus(StepResult.Status.FINISHED);
		} else {
			result.setStatus(StepResult.Status.STEP);
		}
				
		return result;
			
	}// searchStep

}
