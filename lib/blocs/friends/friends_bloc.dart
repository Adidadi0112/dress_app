import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dress_app/blocs/friends/friends_event.dart';
import 'package:dress_app/blocs/friends/friends_state.dart';
import 'package:dress_app/models/friend.dart';
import 'package:dress_app/models/friend_request.dart';
import 'package:dress_app/services/firebase_friends_service.dart';
import 'dart:async';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final FirebaseFriendsService _friendsService = FirebaseFriendsService();

  // Stream subscriptions
  StreamSubscription<List<Friend>>? _friendsSubscription;
  StreamSubscription<List<FriendRequest>>? _receivedRequestsSubscription;
  StreamSubscription<List<FriendRequest>>? _sentRequestsSubscription;

  // Current data
  List<Friend> _friends = [];
  List<FriendRequest> _receivedRequests = [];
  List<FriendRequest> _sentRequests = [];

  FriendsBloc() : super(FriendsInitial()) {
    on<LoadFriends>(_onLoadFriends);
    on<AddFriend>(_onAddFriend);
    on<RemoveFriend>(_onRemoveFriend);
    on<UpdateFriend>(_onUpdateFriend);
    on<InviteFriend>(_onInviteFriend);
    on<SendFriendInvite>(_onSendFriendInvite);
    on<AcceptFriendInvite>(_onAcceptFriendInvite);
    on<RejectFriendInvite>(_onRejectFriendInvite);

    // New Firebase events
    on<SearchUserByEmail>(_onSearchUserByEmail);
    on<SendFriendRequest>(_onSendFriendRequest);
    on<AcceptFriendRequest>(_onAcceptFriendRequest);
    on<RejectFriendRequest>(_onRejectFriendRequest);
    on<LoadPendingRequests>(_onLoadPendingRequests);
    on<LoadSentRequests>(_onLoadSentRequests);
    on<_UpdateFriendsData>(_onUpdateFriendsData);
    on<_UpdateReceivedRequests>(_onUpdateReceivedRequests);
    on<_UpdateSentRequests>(_onUpdateSentRequests);
  }

  void _onLoadFriends(LoadFriends event, Emitter<FriendsState> emit) async {
    emit(FriendsLoading());
    try {
      // Subscribe to friends stream
      await _friendsSubscription?.cancel();
      _friendsSubscription = _friendsService.getFriends().listen((friends) {
        add(_UpdateFriendsData(friends));
      });

      // Subscribe to received requests stream
      await _receivedRequestsSubscription?.cancel();
      _receivedRequestsSubscription =
          _friendsService.getPendingFriendRequests().listen((requests) {
        add(_UpdateReceivedRequests(requests));
      });

      // Subscribe to sent requests stream
      await _sentRequestsSubscription?.cancel();
      _sentRequestsSubscription =
          _friendsService.getSentFriendRequests().listen((requests) {
        add(_UpdateSentRequests(requests));
      });
    } catch (e) {
      emit(FriendsError('Failed to load friends: ${e.toString()}'));
    }
  }

  void _onUpdateFriendsData(
      _UpdateFriendsData event, Emitter<FriendsState> emit) {
    _friends = event.friends;
    _emitCurrentState(emit);
  }

  void _onUpdateReceivedRequests(
      _UpdateReceivedRequests event, Emitter<FriendsState> emit) {
    _receivedRequests = event.requests;
    _emitCurrentState(emit);
  }

  void _onUpdateSentRequests(
      _UpdateSentRequests event, Emitter<FriendsState> emit) {
    _sentRequests = event.requests;
    _emitCurrentState(emit);
  }

  void _emitCurrentState(Emitter<FriendsState> emit) {
    emit(FriendsLoaded(
      friends: List.from(_friends),
      receivedRequests: List.from(_receivedRequests),
      sentRequests: List.from(_sentRequests),
      pendingInvites: _receivedRequests
          .map((req) => Friend(
                id: req.fromUserId,
                name: req.fromUserName,
                email: req.fromUserEmail,
                avatarUrl: req.fromUserProfileImageUrl,
                isConfirmed: false,
              ))
          .toList(),
    ));
  }

  void _onSearchUserByEmail(
      SearchUserByEmail event, Emitter<FriendsState> emit) async {
    try {
      final result = await _friendsService.searchUserByEmail(event.email);

      if (result['type'] == 'success') {
        emit(UserSearchResult(result['data']));
      } else {
        emit(FriendsError(result['message']));
      }
    } catch (e) {
      emit(FriendsError('Failed to search user: ${e.toString()}'));
    }
  }

  void _onSendFriendRequest(
      SendFriendRequest event, Emitter<FriendsState> emit) async {
    try {
      final result =
          await _friendsService.sendFriendRequest(event.targetUserId);

      if (result['type'] == 'success') {
        emit(FriendRequestSent(result['message']));
      } else {
        emit(FriendsError(result['message']));
      }
    } catch (e) {
      emit(FriendsError('Failed to send friend request: ${e.toString()}'));
    }
  }

  void _onAcceptFriendRequest(
      AcceptFriendRequest event, Emitter<FriendsState> emit) async {
    try {
      final result = await _friendsService.acceptFriendRequest(
          event.requestId, event.fromUserId);

      if (result['type'] == 'success') {
        emit(FriendRequestAccepted(result['data']));
      } else {
        emit(FriendsError(result['message']));
      }
    } catch (e) {
      emit(FriendsError('Failed to accept friend request: ${e.toString()}'));
    }
  }

  void _onRejectFriendRequest(
      RejectFriendRequest event, Emitter<FriendsState> emit) async {
    try {
      final result = await _friendsService.rejectFriendRequest(event.requestId);

      if (result['type'] == 'success') {
        emit(FriendRequestRejected(result['message']));
      } else {
        emit(FriendsError(result['message']));
      }
    } catch (e) {
      emit(FriendsError('Failed to reject friend request: ${e.toString()}'));
    }
  }

  // Legacy methods for backward compatibility
  void _onAddFriend(AddFriend event, Emitter<FriendsState> emit) {
    // This is now handled by the real-time streams
    _emitCurrentState(emit);
  }

  void _onRemoveFriend(RemoveFriend event, Emitter<FriendsState> emit) async {
    try {
      final result = await _friendsService.removeFriend(event.friendId);

      if (result['type'] == 'error') {
        emit(FriendsError(result['message']));
      }
    } catch (e) {
      emit(FriendsError('Failed to remove friend: ${e.toString()}'));
    }
  }

  void _onUpdateFriend(UpdateFriend event, Emitter<FriendsState> emit) {
    _emitCurrentState(emit);
  }

  void _onInviteFriend(InviteFriend event, Emitter<FriendsState> emit) async {
    try {
      final searchResult = await _friendsService.searchUserByEmail(event.email);

      if (searchResult['type'] == 'success') {
        final userId = searchResult['data']['id'];
        final requestResult = await _friendsService.sendFriendRequest(userId);

        if (requestResult['type'] == 'success') {
          emit(FriendRequestSent('Friend request sent to ${event.name}'));
        } else {
          emit(FriendsError(requestResult['message']));
        }
      } else {
        emit(FriendsError(searchResult['message']));
      }
    } catch (e) {
      emit(FriendsError('Failed to invite friend: ${e.toString()}'));
    }
  }

  void _onSendFriendInvite(
      SendFriendInvite event, Emitter<FriendsState> emit) async {
    add(InviteFriend(email: event.email, name: event.name));
  }

  void _onAcceptFriendInvite(
      AcceptFriendInvite event, Emitter<FriendsState> emit) async {
    try {
      final request = _receivedRequests.firstWhere(
        (req) => req.fromUserId == event.friendId,
      );
      add(AcceptFriendRequest(request.id, request.fromUserId));
    } catch (e) {
      emit(FriendsError('Request not found'));
    }
  }

  void _onRejectFriendInvite(
      RejectFriendInvite event, Emitter<FriendsState> emit) async {
    try {
      final request = _receivedRequests.firstWhere(
        (req) => req.fromUserId == event.friendId,
      );
      add(RejectFriendRequest(request.id));
    } catch (e) {
      emit(FriendsError('Request not found'));
    }
  }

  void _onLoadPendingRequests(
      LoadPendingRequests event, Emitter<FriendsState> emit) {
    add(LoadFriends());
  }

  void _onLoadSentRequests(LoadSentRequests event, Emitter<FriendsState> emit) {
    add(LoadFriends());
  }

  @override
  Future<void> close() {
    _friendsSubscription?.cancel();
    _receivedRequestsSubscription?.cancel();
    _sentRequestsSubscription?.cancel();
    return super.close();
  }
}

// Internal events for stream updates
class _UpdateFriendsData extends FriendsEvent {
  final List<Friend> friends;
  const _UpdateFriendsData(this.friends);
  @override
  List<Object> get props => [friends];
}

class _UpdateReceivedRequests extends FriendsEvent {
  final List<FriendRequest> requests;
  const _UpdateReceivedRequests(this.requests);
  @override
  List<Object> get props => [requests];
}

class _UpdateSentRequests extends FriendsEvent {
  final List<FriendRequest> requests;
  const _UpdateSentRequests(this.requests);
  @override
  List<Object> get props => [requests];
}
