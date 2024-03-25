import { Module } from "@nestjs/common";
import { TypeOrmModule } from "@nestjs/typeorm";
import { ChronotypeController } from "./chronotype.controller";
import { ChronotypeService } from "./chronotype.service";
import { Chronotype } from "src/entities/chronotype.entity";

@Module({
  imports: [TypeOrmModule.forFeature([Chronotype])],
  controllers: [ChronotypeController],
  providers: [ChronotypeService],
})
export class ChronotypeModule {}
