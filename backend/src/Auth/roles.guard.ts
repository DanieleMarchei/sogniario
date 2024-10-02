// https://docs.nestjs.com/security/authorization

import { Injectable, CanActivate, ExecutionContext, UnauthorizedException, Type, mixin, Query, BadRequestException } from '@nestjs/common';
import { JwtService } from "@nestjs/jwt";
import { Reflector } from '@nestjs/core';
import { UserType } from '../entities/user_type.enum';
import { CreateType, PROTECT_ALTER_KEY, PROTECT_CREATE_KEY, PROTECT_CREATE_USER_KEY, PROTECT_DELETE_KEY, ROLES_KEY } from './roles.decorator';
import e, { Request } from "express";
import { CrudRequest } from '@nestjsx/crud';
// import { ResourceRepositoryService } from 'src/Repository/resourceRepository.service';
import { DataSource, FindOptionsUtils, Repository } from 'typeorm';
import { UserController } from 'src/User/user.controller';
import { User } from 'src/entities/user.entity';
import { Dream } from 'src/entities/dream.entity';
import { DreamController } from 'src/Dream/dream.controller';
import { ChronotypeController } from 'src/Chronotype/chronotype.controller';
import { Chronotype } from 'src/entities/chronotype.entity';
import { PsqiController } from 'src/Psqi/psqi.controller';
import { Psqi } from 'src/entities/psqi.entity';
import { OrganizationController } from 'src/Organization/organization.controller';
import { Organization } from 'src/entities/organization.entity';
import { ResearcherController } from 'src/Researcher/researcher.controller';
import { Researcher } from 'src/entities/researcher.entity';
import { UserService } from 'src/User/user.service';
import { getRepositoryToken } from '@nestjs/typeorm';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(
    private jwtService: JwtService, 
    private reflector: Reflector,
    private userRepo: UserService
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    
    const requiredRoles = this.reflector.getAllAndOverride<UserType[]>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!requiredRoles) {
      return true;
    }


    const request = context.switchToHttp().getRequest();
    const token = this.extractTokenFromHeader(request);
    if (!token) {
      throw new UnauthorizedException();
    }
    try {
      const payload = await this.jwtService.verifyAsync(token, {
        secret: process.env.JWT_SECRET,
      });
      // 💡 We're assigning the payload to the request object here
      // so that we can access it in our route handlers
      request["user"] = payload;
    } catch {
      throw new UnauthorizedException();
    }

    
    const jwtBody = this.jwtService.decode(token);
    const userType = jwtBody["type"];
    const userId = jwtBody["sub"];

    let user = await this.userRepo.findOne({
      where: {id: userId}
    });

    if(user.deleted){
      throw new UnauthorizedException();
    }

    return requiredRoles.some((role) => userType === role);
    

  }

  private extractTokenFromHeader(request: Request): string | undefined {
    const [type, token] = request.headers.authorization?.split(" ") ?? [];
    return type === "Bearer" ? token : undefined;
  }

}

@Injectable()
export class ProtectCreateGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private userRepo: UserService
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {

    let createType = this.reflector.getAllAndOverride<CreateType>(PROTECT_CREATE_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);


    if (createType === undefined) {
      return true;
    } 
    
    const request = context.switchToHttp().getRequest();
    let user = request.user;
    
    if (user.type == UserType.ADMIN) return true;

    let body = createType === CreateType.SINGLE ? [request.body] : request.body.bulk;
    for (let i = 0; i < body.length; i++) {
      const element = body[i];
      let targetUserId = element.user.id ? element.user.id : element.user;
      if(targetUserId === undefined){
        throw new BadRequestException();
      }
      
      let targetUser = await this.userRepo.findOne({
        where : 
        {
          id: targetUserId
        }
      });
      
      if(targetUser === undefined){
        return false;
      }
      
      if(user.type == UserType.USER){
        
        let userId = user.sub;
        if(userId !== targetUserId){
          return false;
        }
      }

      if(user.type == UserType.RESEARCHER){

        let userOrg = user.organization;
        if(userOrg !== targetUser.organization){
          return false;
        }
      }  
    }


    return true;



  }
}

@Injectable()
export class ProtectCreateUserGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private userRepo: UserService
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {

    let createType = this.reflector.getAllAndOverride<CreateType>(PROTECT_CREATE_USER_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);


    if (createType === undefined) {
      return true;
    } 
    
    const request = context.switchToHttp().getRequest();
    let user = request.user;
    
    if (user.type == UserType.ADMIN) return true;
    
    let body = createType === CreateType.SINGLE ? [request.body] : request.body.bulk;

    for (let i = 0; i < body.length; i++) {
      const element = body[i];
      let targetUserId = element.id;
      if(targetUserId !== undefined){
        let targetUser = await this.userRepo.findOne({
          where : 
          {
            id: targetUserId
          }
        });
        
        if(targetUser !== undefined){
          return false;
        }
      }

      if(user.type == UserType.RESEARCHER){

        let userOrg = user.organization;

        if(element.organization === undefined){
          element.organization = userOrg;
        }

        if(userOrg !== element.organization){
          return false;
        }
      }  
    }


    return true;



  }
}


@Injectable()
export class ProtectDeleteGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private dataSource: DataSource,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {

    // TODO: implement delete on cascade
    
    let protect = this.reflector.getAllAndOverride<boolean>(PROTECT_DELETE_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    
    if (protect === undefined) {
      return true;
    } 
    
    return false;
    // take into account create multiple
    const request = context.switchToHttp().getRequest();
    let user = request.user;
    
    if (user.type == UserType.ADMIN) return true;
    let targetResourceId = request.params.id;
    
    if(targetResourceId === undefined){
      throw new BadRequestException();
    }
    
    let entity = this.fromController(context.getClass());
    let repo = this.dataSource.getRepository(entity);

    let relations = entity === User ? undefined : ["user"];

    let targetResource = await repo.findOne({
      where : 
      {
        id: targetResourceId
      },
      relations: relations
    });
    
    if(!targetResource){
      return false;
    }
    
    if(user.type == UserType.USER){
      
      let userId = user.sub;
      let idToCheck = entity === User ? (targetResource as User).id : (targetResource as (Dream | Chronotype | Psqi)).user.id; 
      if(userId !== idToCheck){
        return false;
      }
    }

    if(user.type == UserType.RESEARCHER){

      let userOrg = user.organization;
      let idToCheck = entity === User ? (targetResource as User).organization.id : (targetResource as (Dream | Chronotype | Psqi)).user.organization.id; 
      if(userOrg !== idToCheck){
        return false;
      }
    }  


    return true;



  }

  private fromController(c: Type) : Type<Dream | Chronotype | Psqi | User>{
    switch(c){

      case DreamController: return Dream;

      case ChronotypeController: return Chronotype;
      
      case PsqiController: return Psqi;

      case UserController: return User;

    }
  }
}


@Injectable()
export class ProtectAlterGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private dataSource: DataSource,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {

    let protect = this.reflector.getAllAndOverride<boolean>(PROTECT_ALTER_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (protect === undefined) {
      return true;
    } 
    
    // take into account create multiple
    const request = context.switchToHttp().getRequest();
    let user = request.user;
    
    if (user.type == UserType.ADMIN) return true;

    let targetResourceId = request.params.id;
    
    if(targetResourceId === undefined){
      throw new BadRequestException();
    }
    
    let entity = this.fromController(context.getClass());
    let repo = this.dataSource.getRepository(entity);

    let relations = entity === User ? undefined : ["user"];

    let targetResource = await repo.findOne({
      where : 
      {
        id: targetResourceId
      },
      relations: relations
    });
    
    if(!targetResource){
      return false;
    }


    
    if(user.type == UserType.USER){
      
      let userId = user.sub;
      let idToCheck = entity === User ? (targetResource as User).id : (targetResource as (Dream | Chronotype | Psqi)).user.id; 
      if(userId !== idToCheck){
        return false;
      }
    }
    
    if(user.type == UserType.RESEARCHER){
      
      let userOrg = user.organization;
      let idToCheck = entity === User ? (targetResource as User).organization.id : (targetResource as (Dream | Chronotype | Psqi)).user.organization.id; 
      if(userOrg !== idToCheck){
        return false;
      }
    }

    let body = request.body;
    let targetUserId = undefined;
    if(entity === User){
      targetUserId = body.id;
    }else{
      targetUserId = body.user.id ? body.user.id : body.user;
    }


    let idToCheck = entity === User ? (targetResource as User).id : (targetResource as (Dream | Chronotype | Psqi)).user.id; 

    if(targetUserId !== undefined && idToCheck !== targetUserId){
      throw new BadRequestException();
    }

    return true;



  }

  private fromController(c: Type) : Type<Dream | Chronotype | Psqi | User>{
    switch(c){

      case DreamController: return Dream;

      case ChronotypeController: return Chronotype;
      
      case PsqiController: return Psqi;

      case UserController: return User;

    }
  }
}









    // let hasNecessaryRole = requiredRoles.some((role) => userType === role);
    // if(!hasNecessaryRole) return false;
    
    // if(userType === UserType.ADMIN) return true;
    
    // // remember to add special case for AuthController
    
    // // if user, then it can only call api about his own id
    // // https://expressjs.com/en/api.html#req
    // if(userType == UserType.USER){
    //   let controller = context.getClass();
    //   let entity = this.fromController(controller);
    //   const repository = this.dataSource.getRepository(entity);
    //   let userId = Number.parseInt(jwtBody["sub"]);
      
    //   if(entity === User){
    //     let requestedId = undefined;
        
    //     try {
    //       requestedId = Number.parseInt(request.params.id);
    //     } catch (error) {
    //       throw new UnauthorizedException();
    //     }

    //     return requestedId === userId;
    //   }
      
    //   let caller = context.getHandler();
    //   if(controller.prototype.getOne == caller){
    //     let foundEntity = undefined;
    //     try {
    //       let requestedId = Number.parseInt(request.params.id);
    //       foundEntity = await repository.findOne({
    //         where: {id: requestedId},
    //         relations: ["user"]
    //       });
    //     } catch (error) {
    //       throw new UnauthorizedException();
    //     }
        
    //     if(!foundEntity) throw new UnauthorizedException();

    //     return foundEntity.user.id === userId;

    //   }

    //   if(controller.prototype.getMany == caller){
    //     console.log(request.params)
    //     console.log(request.query)
    //     console.log(request.relations)
    //     let q = await repository.createQueryBuilder().select("id").where(request.query["s"]).leftJoin("user", "u");
    //     console.log(q.getSql());
    //     let o = q.execute();
    //     // let o = await repository.find({
    //     //   where: request.query["s"],
    //     //   relations: ["user"]
    //     // });

    //     console.log(o);

    //   }

    // }
    
    // // if researcher, then it can only call api about his own organization
    // if(userType == UserType.RESEARCHER){
    // }