import { CrudRequest } from "@nestjsx/crud";
import { TypeOrmCrudService } from "@nestjsx/crud-typeorm";
import { UserType } from "src/entities/user_type.enum";

export async function protectByRole<T>(req: CrudRequest, user: any, service : TypeOrmCrudService<T>, entity : string) {
  
    let userType = user.type;
    let userId = user.sub;
    let organizationId = user.organization;
  
    let qb = await service.createBuilder(req.parsed, req.options);
    
    // if (req.parsed.fields && req.parsed.fields.length > 0) {
    //   qb = qb.select(req.parsed.fields.map(field => `"${entity}".${field}`));
    // }else{
    //   // qb = qb.select(`"${entity}".*`)
    // }

    if (req.parsed.limit) {
      qb = qb.limit(req.parsed.limit);
    }

    if (req.parsed.offset) {
      qb = qb.offset(req.parsed.offset);
    } else if (req.parsed.page) {
      qb = qb.offset((req.parsed.page - 1) * req.parsed.limit).limit(req.parsed.limit);
    }

    let userAlias = "User";
    if(entity !== "User"){
      let userAlias = "u";
      qb = qb.leftJoin("user", userAlias, `${entity}.userId = ${userAlias}.id`);
    }

    if(userType == UserType.USER){
      qb = qb.andWhere(`${userAlias}.id = ${userId}`);
      qb = qb.andWhere(`${entity}.deleted = false`); 
    }

    if(userType == UserType.RESEARCHER){
      qb = qb.andWhere(`${userAlias}.organizationId = ` + organizationId);  
      qb = qb.andWhere(`${userAlias}.deleted = false`);
    }
  

    return qb;
  }