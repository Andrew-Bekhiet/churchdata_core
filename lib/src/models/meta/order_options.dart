import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'order_options.g.dart';

@CopyWith(copyWithNull: true)
@immutable
class OrderOptions extends Equatable {
  final String orderBy;
  final bool asc;

  const OrderOptions({
    this.orderBy = 'Name',
    this.asc = true,
  });

  @override
  List<Object?> get props => [orderBy, asc];
}
