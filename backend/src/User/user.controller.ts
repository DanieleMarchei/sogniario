import {
  Controller,
  Get,
  StreamableFile,
  Response,
  Post,
  Body,
  UnauthorizedException,
} from "@nestjs/common";
import { ApiSecurity, ApiTags } from "@nestjs/swagger";
import { CreateManyDto, Crud, CrudController, CrudRequest, GetManyDefaultResponse, Override, ParsedBody, ParsedRequest } from "@nestjsx/crud";
import { User } from "src/entities/user.entity";
import { UserService } from "./user.service";
import { AuthUser, Public } from "src/Auth/auth.decorator";
import { CreateType, ProtectAlter, ProtectCreateUser, ProtectDelete, Roles } from "src/Auth/roles.decorator";
import { DownloadDto } from "./DTO/download.dto";
import { UserType } from "src/entities/user_type.enum";
import { protectByRole } from "src/Auth/roles.util";

@Crud({
  model: {
    type: User,
  },
  query: {
    join: {
      dreams: {},
      psqis: {},
      chronotypes: {},
      organization: {eager:true}
    },
  },
})
@ApiTags("User")
@ApiSecurity("bearer")
@Controller("user")
export class UserController implements CrudController<User> {
  constructor(public service: UserService) {}

  get base(): CrudController<User> {
    return this;
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  async getMany(@ParsedRequest() req: CrudRequest, @AuthUser() user : any): Promise<GetManyDefaultResponse<User> | User[]> {
    let userType = user.type;
    
    if(userType == UserType.RESEARCHER){

        let q = await protectByRole(req, user, this.service, "User");
        let usePagination = this.service.decidePagination(req.parsed, req.options);

        if (usePagination){
          const data = await q.execute();
          const total = await q.getCount();
          const limit = q.expressionMap.take;
          const offset = q.expressionMap.skip;
    
          return this.service.createPageInfo(data, total, limit || total, offset || 0);

        }
        
        return await q.execute();

    }
    return this.base.getManyBase(req);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  async getOne(@ParsedRequest() req: CrudRequest, @AuthUser() user : any): Promise<User> {
    let userType = user.type;
    
    if(userType == UserType.USER || userType == UserType.RESEARCHER){

        let q = await protectByRole(req, user, this.service, "User");
        return await q.execute();

    }
    return this.base.getOneBase(req);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectCreateUser(CreateType.SINGLE)
  async createOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: User): Promise<User> {
    return this.base.createOneBase(req, dto);
  }
  
  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectCreateUser(CreateType.BULK)
  async createMany(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: CreateManyDto<User>): Promise<User[]> {
    return this.base.createManyBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER, UserType.USER)
  @ProtectAlter()
  async updateOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: User): Promise<User> {
    return this.base.updateOneBase(req, dto);
  }
  
  @Override()
  @ProtectAlter()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  async replaceOne(@ParsedRequest() req: CrudRequest, @ParsedBody() dto: User): Promise<User> {
    return this.base.replaceOneBase(req, dto);
  }

  @Override()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @ProtectDelete()
  async deleteOne(@ParsedRequest() req: CrudRequest): Promise<void | User> {
    return this.base.deleteOneBase(req);
  }



  // @Public()
  @Roles(UserType.ADMIN, UserType.RESEARCHER)
  @Post("/download")
  async downloadDreams(
    @Body() downloadDTO: DownloadDto,
    @Response({ passthrough: true }) res,
    @AuthUser() user: any
  ) {
    if(user.type === UserType.RESEARCHER){
      if(user.organization !== downloadDTO.organizationId){
        throw new UnauthorizedException();
      }
    }
    res.set({
      "Content-Type": "application/zip",
      "Content-Disposition": 'attachment; filename="dreamsdump.zip"',
    });
    return new StreamableFile(
      await this.service.downloadDreams(downloadDTO.organizationId)
    );
  }
}
