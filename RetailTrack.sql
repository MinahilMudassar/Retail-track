....--Agent max
SELECT NAME as Agent
FROM  Organizations
WHERE OrganizationID 
IN (
     SELECT OrganizationID
     FROM (
            SELECT TOP 1 OrganizationID, COUNT(*)as TotalMissionassigned 
			FROM Agents
            WHERE AgentID IN (
			                SELECT AgentID 
							FROM Mission_Assignments  
							WHERE AgentID is not null
							)
            GROUP BY   OrganizationID
          )
	      P);